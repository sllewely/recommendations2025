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

    it 'creates a new friendship' do
      new_friend = create(:user)
      token = new_friend.attributes[:friend_code]
      post "/friendships", params: { token: token }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to eq(new_friend.id)
    end

    it 'error if invalid token' do
      new_friend = create(:user)
      token = '12345'
      post "/friendships", params: { token: token }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to eq("user with friend code not found")
    end

    it 'error if nil token' do
      new_friend = create(:user)
      post "/friendships", params: {}, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to eq("friend token required")
    end

  end

end
