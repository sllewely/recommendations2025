require 'rails_helper'

RSpec.describe "Circles", type: :request do
  before(:context) do
    @my_user = create(:user)

    headers = { 'ACCEPT' => 'application/json' }
    post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

    auth_token = JSON.parse(response.body)["auth_token"]
    @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
  end

  describe "GET /circles" do
    it 'gets all my circles' do
      create(:circle, user: @my_user)
      create(:circle, user: @my_user)
      get '/circles', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(2)
    end
  end

  describe "POST /circles" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'fails to create a circle without a name' do
      u1 = create(:user)
      post "/circles", params: { member_ids: [u1.id] }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include("name")
    end

    it 'fails to create a circle without members' do
      post "/circles", params: { name: "my circle" }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include("members")
    end

    it 'fails to create a circle with empty or blank member_ids' do
      post "/circles", params: { name: "my circle", member_ids: ["", nil] }.to_json, headers: @headers.merge({ 'CONTENT_TYPE' => 'application/json' })

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include("members")
    end

    it 'creates a circle with users' do
      u1 = create(:user)
      u2 = create(:user)
      u3 = create(:user)
      post "/circles", params: { name: "my circle", member_ids: [u1.id, u2.id, u3.id] }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['members'].size).to eq(3)
    end
  end

  describe "POST /circles/:id/add" do

  end
end
