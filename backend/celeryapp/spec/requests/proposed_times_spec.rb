require 'rails_helper'
require 'json'

RSpec.describe "ProposedTimes", type: :request do
  before(:all) do
    @my_user = create(:user)

    headers = { 'ACCEPT' => 'application/json' }
    post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

    auth_token = JSON.parse(response.body)["auth_token"]
    @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
  end

  describe 'events with proposed times' do
    it 'creates an event with proposed times' do
      times = [DateTime.now + 5.days, DateTime.now + 6.days].map(&:iso8601)
      post "/events", params: { title: 'k flay', start_date_time: times.first, proposed_times: times }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['proposed_times'].size).to eq(2)
      expect(res['proposed_times'].first['vote_count']).to eq(0)
      expect(Event.find(res['id']).proposed_times.size).to eq(2)
    end

    it 'updates proposed times, keeping votes on times that remain' do
      event = create(:event, user: @my_user)
      kept = create(:proposed_time, event: event, start_date_time: (DateTime.now + 3.days).change(usec: 0))
      removed = create(:proposed_time, event: event)
      create(:proposed_time_user, proposed_time: kept)
      new_time = (DateTime.now + 9.days).iso8601

      patch "/events/#{event.id}", params: { proposed_times: [kept.start_date_time.iso8601, new_time] }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['proposed_times'].size).to eq(2)
      expect(res['proposed_times'].map { |pt| pt['id'] }).to include(kept.id)
      expect(res['proposed_times'].find { |pt| pt['id'] == kept.id }['vote_count']).to eq(1)
      expect(ProposedTime.find_by(id: removed.id)).to be_nil
    end

    it 'leaves proposed times alone when not given' do
      event = create(:event, user: @my_user)
      create(:proposed_time, event: event)

      patch "/events/#{event.id}", params: { title: 'new title' }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(event.proposed_times.count).to eq(1)
    end
  end

  describe 'vote' do
    it 'votes for a proposed time' do
      proposed_time = create(:proposed_time)

      post "/proposed_times/#{proposed_time.id}/vote", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['vote_count']).to eq(1)
      expect(res['users'].first['id']).to eq(@my_user.id)
    end

    it 'voting twice only counts once' do
      proposed_time = create(:proposed_time)

      post "/proposed_times/#{proposed_time.id}/vote", headers: @headers
      post "/proposed_times/#{proposed_time.id}/vote", headers: @headers

      expect(response).to have_http_status(:ok)
      expect(proposed_time.users.count).to eq(1)
    end

    it 'removes a vote' do
      proposed_time = create(:proposed_time)
      create(:proposed_time_user, proposed_time: proposed_time, user: @my_user)
      create(:proposed_time_user, proposed_time: proposed_time)

      delete "/proposed_times/#{proposed_time.id}/vote", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['vote_count']).to eq(1)
      expect(proposed_time.users).not_to include(@my_user)
    end

    it 'returns not found for a missing proposed time' do
      post "/proposed_times/#{SecureRandom.uuid}/vote", headers: @headers

      expect(response).to have_http_status(:not_found)
    end

    it 'shows proposed times and votes on the event' do
      event = create(:event)
      proposed_time = create(:proposed_time, event: event)
      create(:proposed_time_user, proposed_time: proposed_time, user: @my_user)

      get "/events/#{event.id}", headers: @headers

      res = JSON.parse(response.body)
      expect(res['proposed_times'].first['users'].first['id']).to eq(@my_user.id)
    end
  end

  describe 'choose' do
    it 'the host chooses a winning time, which becomes the start time' do
      event = create(:event, user: @my_user)
      proposed_time = create(:proposed_time, event: event, start_date_time: (DateTime.now + 12.days).change(usec: 0))

      post "/proposed_times/#{proposed_time.id}/choose", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['chosen_proposed_time_id']).to eq(proposed_time.id)
      event.reload
      expect(event.start_date_time.to_i).to eq(proposed_time.start_date_time.to_i)
      expect(event.end_date_time).to be > event.start_date_time
    end

    it 'keeps the event length when choosing a time' do
      start = (DateTime.now + 2.days).change(usec: 0)
      event = create(:event, user: @my_user, start_date_time: start, end_date_time: start + 3.hours)
      proposed_time = create(:proposed_time, event: event, start_date_time: start + 5.days)

      post "/proposed_times/#{proposed_time.id}/choose", headers: @headers

      event.reload
      expect(event.end_date_time - event.start_date_time).to eq(3.hours)
    end

    it 'only the host can choose a time' do
      event = create(:event)
      proposed_time = create(:proposed_time, event: event)

      post "/proposed_times/#{proposed_time.id}/choose", headers: @headers

      expect(response).to have_http_status(:forbidden)
      expect(event.reload.chosen_proposed_time_id).to be_nil
    end

    it 'clears the winner when the start time is moved off of it' do
      event = create(:event, user: @my_user)
      proposed_time = create(:proposed_time, event: event)
      event.choose_proposed_time!(proposed_time)

      patch "/events/#{event.id}", params: { start_date_time: (proposed_time.start_date_time + 1.day).iso8601 }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(event.reload.chosen_proposed_time_id).to be_nil
    end
  end
end
