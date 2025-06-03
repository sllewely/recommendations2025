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
      expect(res['friend_request']['user_id']).to eq new_friend.id
      expect(res['friend_request']['incoming_friend_id']).to eq @my_user.id
    end

    it 'does not find a friend request, if it doesnt exist' do
      new_friend = create(:user)
      get "/friend_requests/#{new_friend.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['friend_request']).to be_nil
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
      expect(res['incoming_friend_requests'].first.keys).to include("name")
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
      expect(res['outgoing_friend_requests'].first.keys).to include("name")
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
      expect(res['id']).to eq(new_friend.id)
    end

    it 'fails if a friend request already exists' do
      new_friend = create(:user)
      post "/friend_requests", params: { user_id: new_friend.id }, headers: @headers
      post "/friend_requests", params: { user_id: new_friend.id }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include('duplicate key value violates unique constraint')
    end

    it 'sends a pending friend request email' do
      new_friend = create(:user)
      post "/friend_requests", params: { user_id: new_friend.id }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to eq(new_friend.id)

      email = ActionMailer::Base.deliveries.last
      assert_includes email.body.to_s, "You have a new friend request!"
    end
  end
end
