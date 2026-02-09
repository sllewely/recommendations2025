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

    it 'creates an event and sends your friends a notification' do
      friend = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, friend)

      post "/events", params: { title: 'k flay', description: "come see this fun show with me", start_date_time: DateTime.now + 5.days, }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['title']).to eq('k flay')
      expect(res['start_date_time']).to_not be_nil
      expect(res['end_date_time']).to_not be_nil

      expect(friend.notifications.size).to eq(1)
      expect(friend.notifications.first.message).to eq("#{@my_user.name} created a new event")
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

      @friend = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, @friend)
    end

    it 'retrieves a list of events' do
      create(:event, user: @my_user)
      create(:event, user: @friend)
      create(:event, user: @friend)

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(3)
      expect(res.first['title']).to_not be_nil

    end

    it 'wont show me events by non-friend users' do
      create(:event, user: @my_user)
      create(:event, user: other_user)
      create(:event, user: other_user)

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(1)
      expect(res.first['title']).to_not be_nil

    end

    it 'retrieves a list of events, with creator_name and id' do
      create(:event, user: @friend)
      create(:event, user: @friend)
      create(:event, user: @friend)

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(3)
      expect(res.first['user']['name']).to eq(@friend.name)
      expect(res.first['user']['id']).to eq(@friend.id)
    end

    it 'retrieves a list of events, with rsvps' do
      event1 = create(:event, user: @friend)
      event2 = create(:event, user: @friend)
      create(:rsvp, event: event1, user: @my_user, status: 'going')
      create(:rsvp, event: event1, user: @friend)
      create(:rsvp, event: event2, user: @my_user)
      create(:rsvp, event: event2, user: @friend, status: 'hide')

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(2)
      # non deterministic
      expect(res[0]['rsvps'].size).to eq(2)

      expect(res.first['rsvps'].size).to eq(2)
      expect(res.first['user']['name']).to_not be_nil
      expect(res.first['user']['id']).to_not be_nil
    end

  end

  describe 'show' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }

      @friend = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, @friend)
    end

    it 'gets a specific event' do
      event = create(:event, user: @my_user)

      get "/events/#{event.id}", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res['start_date_string']).to match(/\d?\d\/\d?\d\/\d\d\d\d/)
      expect(res['start_time_string']).to match(/\d?\d:\d\d/)
    end

    it 'gets an event with rsvps' do
      event = create(:event, user: @friend)
      create(:rsvp, user: @my_user, event: event)

      get "/events/#{event.id}", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res['start_date_string']).to match(/\d?\d\/\d?\d\/\d\d\d\d/)
      expect(res['start_time_string']).to match(/\d?\d:\d\d/)
      expect(res['rsvps'].first['status']).to eq('interested')
    end

    it 'has comments' do
      event = create(:event, user: @friend)
      create(:comment, :for_event, commentable: event, user: @my_user)
      create(:comment, :for_event, commentable: event, user: @friend)

      get "/events/#{event.id}", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res['comments'].size).to eq(2)
      expect(res['comments'].first['body']).to_not be_nil
    end

  end

  describe 'update' do
    let(:other_user) { create(:user) }

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'updates my event' do
      event = create(:event, user: @my_user)

      patch "/events/#{event.id}", params: { title: "new title" }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['title']).to eq("new title")
    end

    it 'fails if editing someone elses event' do
      event = create(:event)

      patch "/events/#{event.id}", params: { title: "new title" }, headers: @headers

      expect(response).to have_http_status(:not_found)
      res = JSON.parse(response.body)
      expect(res['error']).to eq("event not found")
    end

  end

  describe 'destroy' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }

      @friend = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, @friend)
    end

    it 'deletes my event' do
      event = create(:event, user: @my_user)

      delete "/events/#{event.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:no_content)
      deleted_event = Event.find_by(id: event.id)
      expect(deleted_event).to be_nil
    end

    it 'cannot delete someone elses event' do
      event = create(:event, user: @friend)

      delete "/events/#{event.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:not_found)
      deleted_event = Event.find_by(id: event.id)
      expect(deleted_event).to_not be_nil
    end

  end
end