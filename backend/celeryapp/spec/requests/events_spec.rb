require 'rails_helper'
require 'json'

RSpec.describe "Events", type: :request do
  describe 'create' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates an event' do

      post "/events", params: { title: 'k flay', description: "come see this fun show with me", start_date_time: DateTime.now + 5.days, }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['title']).to eq('k flay')
      expect(res['start_date_time']).to_not be_nil
      expect(res['end_date_time']).to_not be_nil
    end

    it 'creates an event with end time' do
      post "/events", params: { title: 'k flay', description: "come see this fun show with me", start_date_time: DateTime.now + 5.days, end_date_time: DateTime.now + 10.days }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['title']).to eq('k flay')
    end

    it 'creates a public event' do
      post "/events", params: { title: 'k flay', description: "come see this fun show with me", start_date_time: DateTime.now + 5.days, is_public: true }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['title']).to eq('k flay')
      expect(res['is_public']).to eq(true)
    end

    it 'requires a title' do

      post "/events", params: { description: "come see this fun show with me", start_date_time: DateTime.now + 5.days, }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to eq("title: can't be blank")
    end

    it 'requires a time' do

      post "/events", params: { title: 'k flay', description: "come see this fun show with me" }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to eq("start_date_time: can't be blank")
    end
  end

  describe 'index' do
    let(:other_user) { create(:user) }

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'retrieves a list of events' do
      create(:event, user: @my_user)
      create(:event, user: other_user)
      create(:event, user: other_user)

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(3)
      expect(res.first['title']).to_not be_nil

    end

    it 'retrieves a list of events, with creator_name and id' do
      create(:event, user: other_user)
      create(:event, user: other_user)
      create(:event, user: other_user)

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(3)
      expect(res.first['creator_name']).to eq(other_user.name)
      expect(res.first['creator_id']).to eq(other_user.id)
    end

    it 'retrieves a list of events, with rsvps' do
      event1 = create(:event, user: other_user)
      event2 = create(:event, user: other_user)
      create(:rsvp, event: event1, user: @my_user, status: 'going')
      create(:rsvp, event: event1, user: other_user)
      create(:rsvp, event: event2, user: @my_user)
      create(:rsvp, event: event2, user: other_user, status: 'not_interested')

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(2)
      # non deterministic
      expect(res[0]['rsvps'].size).to eq(2)
      expect(res.first['current_user_rsvp']).to eq('going')
      expect(res.first['creator_name']).to eq(other_user.name)
      expect(res.first['creator_id']).to eq(other_user.id)
    end

  end

  describe 'show' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'gets a specific event' do
      event = create(:event)

      get "/events/#{event.id}", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res['start_date_string']).to match(/\d?\d\/\d?\d\/\d\d\d\d/)
      expect(res['start_time_string']).to match(/\d?\d:\d\d/)
    end

    it 'gets an event with rsvps' do
      event = create(:event)
      create(:rsvp, user: @my_user, event: event)

      get "/events/#{event.id}", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res['start_date_string']).to match(/\d?\d\/\d?\d\/\d\d\d\d/)
      expect(res['start_time_string']).to match(/\d?\d:\d\d/)
      expect(res['current_user_rsvp']).to eq('interested')
    end

  end
end