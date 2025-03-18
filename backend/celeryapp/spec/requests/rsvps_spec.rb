require 'rails_helper'
require 'json'

RSpec.describe "Rsvps", type: :request do
  describe "POST /rsvps" do

    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates a new rsvp' do
      event = create(:event)
      post "/rsvps", params: { event_id: event.id }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to_not be_nil
      expect(res['status']).to eq("interested")
    end

  end

  describe "GET /rsvps" do

    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    # it 'gets recommendations for given user' do
    #   create(:recommendation, user: @my_user)
    #   create(:recommendation, user: @my_user)
    #   create(:recommendation)
    #
    #   get "/rsvps", params: { user_id: @my_user.id }, headers: @headers
    #
    #   expect(response).to have_http_status(:ok)
    #   res = JSON.parse(response.body)
    #   expect(res.size).to eq(2)
    # end
    #
    # it 'needs a user id passed' do
    #   create(:recommendation, user: @my_user)
    #   create(:recommendation, user: @my_user)
    #   create(:recommendation)
    #
    #   get "/rsvps", params: {}, headers: @headers
    #
    #   expect(response).to have_http_status(:bad_request)
    #   res = JSON.parse(response.body)
    #   expect(res['error']).to eq('Error expected param user_id')
    # end

  end

  describe "GET /rsvps/:id" do

    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    # it 'gets a specific recommendation' do
    #   recommendation = create(:recommendation, user: @my_user)
    #
    #   get "/rsvps/#{recommendation.id}", headers: @headers
    #
    #   expect(response).to have_http_status(:ok)
    #   res = JSON.parse(response.body)
    #   expect(res['title']).to eq(recommendation.title)
    # end
    #
    # it 'fails if the recommendation does not exist' do
    #   create(:recommendation, user: @my_user)
    #
    #   get "/rsvps/1234", params: {}, headers: @headers
    #
    #   expect(response).to have_http_status(:not_found)
    # end
  end

  describe "POST /rsvps/:id" do

    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    # it 'updates the recommendation' do
    #   recommendation = create(:recommendation, user: @my_user)
    #
    #   patch "/rsvps/#{recommendation.id}", params: { notes: "I'm a fan" }, headers: @headers
    #
    #   expect(response).to have_http_status(:ok)
    #   res = JSON.parse(response.body)
    #   expect(res['notes']).to eq("I'm a fan")
    # end
    #
    # it 'fails if the user does not own the recommendation' do
    #   recommendation = create(:recommendation)
    #
    #   patch "/rsvps/#{recommendation.id}", params: { notes: "I'm a fan" }, headers: @headers
    #
    #   expect(response).to have_http_status(:not_found)
    # end
    #
    # it 'cannot update the recommendation to be the same as another' do
    #   recommendation = create(:recommendation, user: @my_user)
    #   recommendation2 = create(:recommendation, user: @my_user)
    #
    #   patch "/rsvps/#{recommendation2.id}", params: { title: recommendation.title, media_type: recommendation.media_type }, headers: @headers
    #
    #   expect(response).to have_http_status(:unprocessable_content)
    # end

  end

end
