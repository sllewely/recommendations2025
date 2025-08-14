require 'rails_helper'
require 'json'

RSpec.describe "UserStatuses", type: :request do
  describe "GET /user_statuses" do
    before(:context) do
      @my_user = create(:user)
      @friend = create(:user)
      @friend_2 = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, @friend)
      Friendship.create_bidirectional_friendship!(@my_user, @friend_2)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'returns the user statuses for the current user' do
      skip "not filtering by friends for now"
      @user_status = create(:user_status, user: @friend)
      @user_status_2 = create(:user_status, user: @friend_2)

      get "/user_statuses", headers: @headers
      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.length).to eq(2)
      expect(res[0]['id']).to eq(@user_status.id)
      expect(res[1]['id']).to eq(@user_status_2.id)
    end
  end

  describe "POST /user_statuses" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates a new user status' do
      post "/user_statuses", params: { user_status: { status: "Feeling great!" } }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to_not be_nil
      expect(res['status']).to eq("Feeling great!")
      expect(res['user_id']).to eq(@my_user.id)
    end

    it 'requires a status' do
      post "/user_statuses", params: { user_status: { status: "" } }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include("can't be blank").or include("Status can't be blank")
    end
  end
end
