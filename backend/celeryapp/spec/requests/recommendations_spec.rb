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

    it 'creates a new recommendation with url' do
      post "/recommendations", params: { title: "Annihilation", notes: "A book I like", url: "https://en.wikipedia.org/wiki/Annihilation_(VanderMeer_novel)" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to_not be_nil
      expect(res['title']).to eq("Annihilation")
      expect(res['url']).to eq("https://en.wikipedia.org/wiki/Annihilation_(VanderMeer_novel)")
    end

    it 'requires a title' do
      post "/recommendations", params: { notes: "A book I like" }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to eq("title: can't be blank")
    end

    it 'must be unique for the user, title, and media type' do
      recommendation = create(:recommendation, user: @my_user)

      post "/recommendations", params: { title: recommendation.title, notes: "A book I like", media_type: recommendation.media_type }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
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

    it 'will not get the recommendation if not by my friend' do
      recommendation = create(:recommendation)

      get "/recommendations/#{recommendation.id}", headers: @headers

      expect(response).to have_http_status(:not_found)
      res = JSON.parse(response.body)
      expect(res['error']).to eq('not found')
    end

    it 'fails if the recommendation does not exist' do
      create(:recommendation, user: @my_user)

      get "/recommendations/1234", params: {}, headers: @headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /recommendations/:id" do

    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'updates the recommendation' do
      recommendation = create(:recommendation, user: @my_user)

      patch "/recommendations/#{recommendation.id}", params: { notes: "I'm a fan" }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['notes']).to eq("I'm a fan")
    end

    it 'fails if the user does not own the recommendation' do
      recommendation = create(:recommendation)

      patch "/recommendations/#{recommendation.id}", params: { notes: "I'm a fan" }, headers: @headers

      expect(response).to have_http_status(:not_found)
    end

    it 'cannot update the recommendation to be the same as another' do
      recommendation = create(:recommendation, user: @my_user)
      recommendation2 = create(:recommendation, user: @my_user)

      patch "/recommendations/#{recommendation2.id}", params: { title: recommendation.title, media_type: recommendation.media_type }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
    end

  end

end
