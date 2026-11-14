require 'rails_helper'
require 'json'

RSpec.describe "Notifications", type: :request do
  def friend_notification(user, friend)
    notif = Notification.accepted_friendship_notification(friend)
    notif.user = user
    notif.save!
    notif
  end

  describe "GET /index" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'gets my notifications' do
      friend_notification(@my_user, create(:user))
      friend_notification(@my_user, create(:user))

      get "/notifications", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['notifications'].size).to eq(2)
      expect(res['notifications'][0]['message']).to include("is now your friend!")
      expect(res['notifications'][0]['extras']['user_id']).to_not be_nil
    end

    it 'leaves out old pending friend request notifications' do
      requester = create(:user)
      Notification.create!(user: @my_user, notif_type: :pending_friend_request,
                           message: "You have a pending friend request from #{requester.name}",
                           extras: { user_id: requester.id })

      get "/notifications", headers: @headers

      res = JSON.parse(response.body)
      expect(res['notifications'].map { |n| n['notif_type'] }).to_not include('pending_friend_request')
    end

  end

  describe "GET /has_active" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'returns true if I have active notifications' do
      friend_notification(@my_user, create(:user))

      get "/notifications/has_active", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['has_active']).to be true
    end

    it 'returns false if my notifs are read' do
      notif = friend_notification(@my_user, create(:user))

      patch "/notifications/#{notif.id}", params: { active: false }, headers: @headers
      expect(response).to have_http_status(:ok)

      get "/notifications/has_active", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['has_active']).to be false
    end

    it 'returns true if a friend request is waiting on me' do
      other = create(:user)
      @my_user.friend_requests.create!(incoming_friend_id: other.id)

      get "/notifications/has_active", headers: @headers

      res = JSON.parse(response.body)
      expect(res['has_active']).to be true
    end

  end

  describe "PATCH /update" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'marks a notification read' do
      notif = friend_notification(@my_user, create(:user))

      patch "/notifications/#{notif.id}", params: { active: false }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['active']).to be_falsey
    end

  end

end
