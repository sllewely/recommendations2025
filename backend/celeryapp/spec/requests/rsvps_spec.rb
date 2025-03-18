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

    it 'creates a new rsvp' do
      event = create(:event)
      post "/rsvps", params: { event_id: event.id, status: 'going' }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to_not be_nil
      expect(res['status']).to eq("going")
    end

    it 'event is required' do
      post "/rsvps", params: {}, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
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

    it 'gets recommendations for given user' do
      event = create(:event)
      event2 = create(:event)
      other_user = create(:user)
      create(:rsvp, user: other_user, event: event)
      create(:rsvp, user: @my_user, event: event)
      create(:rsvp, user: @my_user, event: event2)

      get "/rsvps", params: { user_id: @my_user.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(2)
    end

  end

  describe "POST /rsvps/:id" do

    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'updates the rsvp' do
      event = create(:event)
      rsvp = create(:rsvp, user: @my_user, event: event)

      patch "/rsvps/#{rsvp.id}", params: { status: 'going' }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['status']).to eq("going")
    end
  end

end
