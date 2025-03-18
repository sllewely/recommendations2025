require 'rails_helper'
require 'json'

RSpec.describe "Recommendations", type: :request do
  describe "POST /recommendations" do

    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates a new recommendation' do
      post "/recommendations", params: { title: "Annihilation", notes: "A book I like" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to_not be_nil
      expect(res['title']).to eq("Annihilation")
    end

    it 'creates a new recommendation interested in' do
      post "/recommendations", params: { title: "Annihilation", notes: "A book I like", status: 'watching' }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to_not be_nil
      expect(res['title']).to eq("Annihilation")
      expect(res['status']).to eq('watching')
    end
  end

  describe "GET /recommendations" do

    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'gets recommendations for given user' do
      create(:recommendation, user: @my_user)
      create(:recommendation, user: @my_user)
      create(:recommendation)

      get "/recommendations", params: { user_id: @my_user.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(2)
    end

    it 'needs a user id passed' do
      create(:recommendation, user: @my_user)
      create(:recommendation, user: @my_user)
      create(:recommendation)

      get "/recommendations", params: {}, headers: @headers

      expect(response).to have_http_status(:bad_request)
      res = JSON.parse(response.body)
      expect(res['error']).to eq('Error expected param user_id')
    end

  end

  describe "GET /recommendations/:id" do

    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'gets a specific recommendation' do
      recommendation = create(:recommendation, user: @my_user)

      get "/recommendations/#{recommendation.id}", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['title']).to eq(recommendation.title)
    end

    it 'fails if the recommendation does not exist' do
      create(:recommendation, user: @my_user)

      get "/recommendations/1234", params: {}, headers: @headers

      expect(response).to have_http_status(:not_found)
    end

  end

end
