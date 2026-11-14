require 'rails_helper'
require 'json'

RSpec.describe "Notifications", type: :request do

  describe "GET /index" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'gets my pending friend notifications' do
      new_friend1 = create(:user)
      new_friend2 = create(:user)
      Notification.pending_friend_request(@my_user, new_friend1).save!
      Notification.pending_friend_request(@my_user, new_friend2).save!

      get "/notifications", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['notifications'].size).to eq(2)
      expect(res['notifications'][0]['message']).to include("You have a pending friend request from")
      expect(res['notifications'][0]['extras']['user_id']).to_not be_nil
    end

    it 'includes the friend request and where it stands' do
      sender = create(:user)
      friend_request = create(:friend_request, user: @my_user, incoming_friend: sender, message: "hi!")
      Notification.pending_friend_request(@my_user, sender, friend_request).save!

      get "/notifications", headers: @headers

      notif = JSON.parse(response.body)['notifications'].find { |n| n['extras']['user_id'] == sender.id }
      expect(notif['friend_request']['id']).to eq(friend_request.id)
      expect(notif['friend_request']['status']).to eq("pending")
      expect(notif['friend_request']['message']).to eq("hi!")
      expect(notif['friend_request']['user']['id']).to eq(sender.id)

      friend_request.rejected!
      get "/notifications", headers: @headers
      notif = JSON.parse(response.body)['notifications'].find { |n| n['extras']['user_id'] == sender.id }
      expect(notif['friend_request']['status']).to eq("ignored")
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
      new_friend1 = create(:user)
      new_friend2 = create(:user)
      Notification.pending_friend_request(@my_user, new_friend1).save!
      Notification.pending_friend_request(@my_user, new_friend2).save!

      get "/notifications/has_active", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['has_active']).to be true
    end

    it 'returns false if my notifs are read' do
      new_friend1 = create(:user)
      notif = Notification.pending_friend_request(@my_user, new_friend1)
      notif.save!

      patch "/notifications/#{notif.id}", params: { active: false }, headers: @headers
      expect(response).to have_http_status(:ok)

      get "/notifications/has_active", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['has_active']).to be false
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

    it 'gets my pending friend notifications' do
      new_friend1 = create(:user)
      notif = Notification.pending_friend_request(@my_user, new_friend1)
      notif.save!

      patch "/notifications/#{notif.id}", params: { active: false }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['active']).to be_falsey
    end

  end

end
