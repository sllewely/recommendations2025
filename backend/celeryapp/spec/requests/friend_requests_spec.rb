require 'rails_helper'
require 'json'

RSpec.describe "FriendRequests", type: :request do

  describe "GET /friend_requests/:id" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'gets my friend request to the user, if it exists' do
      new_friend = create(:user)
      create(:friend_request, user: new_friend, incoming_friend: @my_user)
      get "/friend_requests/#{new_friend.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['user']['id']).to eq new_friend.id
      expect(res['incoming_friend']['id']).to eq @my_user.id
    end

    it 'does not find a friend request, if it doesnt exist' do
      new_friend = create(:user)
      get "/friend_requests/#{new_friend.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:not_found)
      res = JSON.parse(response.body)
      expect(res).to eq({})
    end

  end

  describe "GET /index" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'lists my friend requests' do
      new_friend = create(:user)
      new_friend2 = create(:user)
      create(:friend_request, user: @my_user, incoming_friend: new_friend)
      create(:friend_request, user: @my_user, incoming_friend: new_friend2)
      get "/friend_requests", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(2)
      expect(res['incoming_friend_requests'].size).to eq(2)
      expect(res['incoming_friend_requests'].first['user']['name']).to_not be_nil
      expect(res['outgoing_friend_requests'].size).to eq(0)
    end

    it 'lists my friend requests' do
      new_friend = create(:user)
      new_friend2 = create(:user)
      create(:friend_request, user: new_friend, incoming_friend: @my_user)
      create(:friend_request, user: new_friend2, incoming_friend: @my_user)
      get "/friend_requests", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(2)
      expect(res['outgoing_friend_requests'].size).to eq(2)
      expect(res['outgoing_friend_requests'].first['user']['name']).to_not be_nil
    end

  end

  describe "POST /friend_requests" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates a new friendship request' do
      new_friend = create(:user)
      post "/friend_requests", params: { user_id: new_friend.id }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['user']['id']).to eq(new_friend.id)
    end

    it 'fails if a friend request already exists to them' do
      new_friend = create(:user)
      post "/friend_requests", params: { user_id: new_friend.id }, headers: @headers
      post "/friend_requests", params: { user_id: new_friend.id }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include('Validation failed: You already have a pending friend request to')
    end

    it 'fails if an incoming friend request already exists from them' do
      new_friend = create(:user)
      fr = create(:friend_request, user: @my_user, incoming_friend: new_friend)
      post "/friend_requests", params: { user_id: new_friend.id }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include('Validation failed: You already have a pending friend request from')
    end

    it 'fails if were already friends' do
      new_friend = create(:user)
      create(:friendship, user: @my_user, friend: new_friend)
      create(:friendship, user: new_friend, friend: @my_user)
      post "/friend_requests", params: { user_id: new_friend.id }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include("Cannot send friend request: already friends")
    end

    it 'sends a pending friend request email' do
      new_friend = create(:user)
      post "/friend_requests", params: { user_id: new_friend.id }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['user']['id']).to eq(new_friend.id)

      email = ActionMailer::Base.deliveries.last
      assert_includes email.body.to_s, "You have a new friend request from #{@my_user.name}!"
    end
  end
end
