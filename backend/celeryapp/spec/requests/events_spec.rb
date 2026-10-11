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

      post "/events", params: { title: 'k flay', description: "come see this fun show with me", start_date_time: DateTime.now + 5.days }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['title']).to eq('k flay')
      expect(res['start_date_time']).to_not be_nil
      expect(res['end_date_time']).to_not be_nil
    end

    it 'creates a feed item if public' do

      post "/events", params: { title: 'k flay', description: "come see this fun show with me", start_date_time: DateTime.now + 5.days }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['title']).to eq('k flay')
      expect(res['start_date_time']).to_not be_nil
      expect(res['end_date_time']).to_not be_nil
      expect(res['id']).to be_present

      event = Event.find_by(id: res['id'])
      expect(event.feed_item).to be_present
    end

    it 'creates an event with end time' do
      post "/events", params: { title: 'k flay', description: "come see this fun show with me", start_date_time: DateTime.now + 5.days, end_date_time: DateTime.now + 10.days }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['title']).to eq('k flay')
    end

    it 'requires a title' do

      post "/events", params: { description: "come see this fun show with me", start_date_time: DateTime.now + 5.days }, headers: @headers

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

      post "/events", params: {
        title: 'k flay',
        description: "come see this fun show with me",
        start_date_time: DateTime.now + 5.days,
      }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['title']).to eq('k flay')
      expect(res['start_date_time']).to_not be_nil
      expect(res['end_date_time']).to_not be_nil

      expect(friend.notifications.size).to eq(1)
      expect(friend.notifications.first.message).to eq("#{@my_user.name} created a new event")
    end

    it 'creates a private event and invites your friends' do
      friend = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, friend)
      post "/events", params: {
        title: 'k flay',
        description: "come see this fun show with me",
        start_date_time: DateTime.now + 5.days,
        privacy: "specific",
        invited_friend_ids: [friend.id]
      }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['title']).to eq('k flay')
      expect(Event.find_by(id: res['id']).rsvps.size).to eq(1)
      expect(friend.rsvps.size).to eq(1)
      expect(friend.notifications.first.message).to eq("#{@my_user.name} invited you to an event")
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

    # rolling back friendship
    skip 'wont show me events by non-friend users' do
      create(:event, user: @my_user)
      create(:event, user: other_user)
      create(:event, user: other_user)

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(1)
      expect(res.first['title']).to_not be_nil

    end

    it 'will show me events by non-friend users' do
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

    it 'doesnt show private events' do
      event1 = create(:event, user: @friend)
      event1.apply_privacy!(visibility: "specific")

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(0)
    end

    it 'I can see a private event if im in the audience' do
      event1 = create(:event, user: @friend)
      event1.apply_privacy!(visibility: "specific", user_ids: [@my_user.id])

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(1)
    end

    it 'I can see a friends only event from my friend' do
      event1 = create(:event, user: @friend)
      event1.apply_privacy!(visibility: "friends")
      event2 = create(:event, user: other_user)
      event2.apply_privacy!(visibility: "friends")

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.map { |e| e['id'] }).to eq([event1.id])
    end

    it 'I can see a private event if its mine' do
      event1 = create(:event, user: @my_user)
      event1.apply_privacy!(visibility: "specific")

      get '/events', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(1)
      expect(res.first['visibility']).to eq('specific')
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

    it 'returns not found for a private event im not invited to' do
      event = create(:event, user: @friend)
      event.apply_privacy!(visibility: "specific")

      get "/events/#{event.id}", headers: @headers

      expect(response).to have_http_status(:not_found)
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

    it 'removes notifications when a user is removed from the private event' do
      friend1 = create(:user)
      friend2 = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, friend1)
      Friendship.create_bidirectional_friendship!(@my_user, friend2)
      post "/events", params: {
        title: 'k flay',
        description: "come see this fun show with me",
        start_date_time: DateTime.now + 5.days,
        privacy: "specific",
        invited_friend_ids: [friend1.id, friend2.id]
      }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      event = Event.find_by(id: res['id'])
      expect(friend2.notifications.size).to eq(1)

      patch "/events/#{event.id}", params: { title: "new title", invited_friend_ids: [friend1.id] }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      event = Event.find_by(id: res['id'])
      expect(event.rsvps.size).to eq(1)
      expect(friend2.notifications.size).to eq(0)

    end

    it 'adds notifications when a user is added to the private event' do
      friend1 = create(:user)
      friend2 = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, friend1)
      Friendship.create_bidirectional_friendship!(@my_user, friend2)
      post "/events", params: {
        title: 'k flay',
        description: "come see this fun show with me",
        start_date_time: DateTime.now + 5.days,
        privacy: "specific",
        invited_friend_ids: [friend1.id]
      }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      event = Event.find_by(id: res['id'])
      expect(friend2.notifications.size).to eq(0)

      patch "/events/#{event.id}", params: { title: "new title", invited_friend_ids: [friend1.id, friend2.id] }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      event = Event.find_by(id: res['id'])
      friend2 = User.find(friend2.id)
      expect(event.rsvps.size).to eq(2)
      expect(friend2.notifications.size).to eq(1)
      expect(event.visible_to?(friend2)).to be true
    end

    it 'creates a private event with a feed item only invitees can see' do
      friend1 = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, friend1)
      post "/events", params: {
        title: 'k flay',
        start_date_time: DateTime.now + 5.days,
        privacy: "specific",
        invited_friend_ids: [friend1.id]
      }, headers: @headers

      expect(response).to have_http_status(:created)
      event = Event.find(JSON.parse(response.body)['id'])
      expect(event.feed_item).to be_present
      expect(event.visible_to?(friend1)).to be true
      expect(event.visible_to?(other_user)).to be false
    end

    it 'switches an event to public' do
      event = create(:event, user: @my_user)
      event.apply_privacy!(visibility: "specific")

      patch "/events/#{event.id}", params: { privacy: "public" }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['visibility']).to eq('public')
      expect(Event.public_events).to include(event)
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