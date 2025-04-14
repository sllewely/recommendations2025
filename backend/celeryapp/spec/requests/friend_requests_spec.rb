require 'rails_helper'
require 'json'

RSpec.describe "FriendRequests", type: :request do
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
      expect(res.first.keys).to include("name")
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
      token = new_friend.attributes[:friend_code]
      post "/friend_requests", params: { token: token }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to eq(new_friend.id)
    end
  end
end
