require 'rails_helper'
require 'json'

RSpec.describe "Friendships", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "POST /friendships" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates a new friendship from friend request' do
      new_friend = create(:user)
      create(:friend_request, user: @my_user, incoming_friend: new_friend)
      post "/friendships", params: { friend_id: new_friend.id }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to eq(new_friend.id)
    end

    it 'errors if there is no friend request' do
      new_friend = create(:user)

      post "/friendships", params: { friend_id: new_friend.id }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to eq("pending friend request not found")
    end

    # it 'error if invalid token' do
    #   new_friend = create(:user)
    #   token = '12345'
    #   post "/friendships", params: { token: token }, headers: @headers
    #
    #   expect(response).to have_http_status(:unprocessable_content)
    #   res = JSON.parse(response.body)
    #   expect(res['error']).to eq("user with friend code not found")
    # end

    # it 'error if nil token' do
    #   new_friend = create(:user)
    #   post "/friendships", params: {}, headers: @headers
    #
    #   expect(response).to have_http_status(:unprocessable_content)
    #   res = JSON.parse(response.body)
    #   expect(res['error']).to eq("friend token required")
    # end

    it 'error if friendship already exists' do
      new_friend = create(:user)
      create(:friend_request, user: @my_user, incoming_friend: new_friend)
      post "/friendships", params: { friend_id: new_friend.id }, headers: @headers
      post "/friendships", params: { friend_id: new_friend.id }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include('duplicate key value violates unique constraint')
    end

  end

end
