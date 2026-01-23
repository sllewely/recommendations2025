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
      debugger
      expect(res['notifications'].size).to eq(2)
      expect(res['notifications'][0]['message']).to include("You have a pending friend request from")
      expect(res['notifications'][0]['extras']['user_id']).to_not be_nil
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
