require 'rails_helper'

RSpec.describe "WebPushRegistrations", type: :request do
  describe "POST /web_push_registrations" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates a new web push registration' do
      post "/web_push_registrations", params: { endpoint: "https://example.com/endpoint", p256dh: "p256dh", auth: "auth" }, headers: @headers
      expect(response).to have_http_status(:created)

      user = User.find(@my_user.id)
      expect(user.web_push_registrations.count).to eq(1)
    end
  end

  describe "GET /web_push_registrations" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'checks if the user has active registrations' do
      create(:web_push_registration, user: @my_user, expires_at: Time.now + 1.day)
      create(:web_push_registration, user: @my_user, expires_at: Time.now + 5.day)
      create(:web_push_registration, user: @my_user, expires_at: Time.now + 110.day)

      get "/web_push_registrations", headers: @headers
      expect(response).to have_http_status(:ok)

      res = JSON.parse(response.body)
      expect(res['active_registrations_count']).to eq(3)
    end

    it 'checks if the user has active registrations, when the expiration date is null' do
      create(:web_push_registration, user: @my_user, expires_at: nil)
      create(:web_push_registration, user: @my_user, expires_at: nil)
      create(:web_push_registration, user: @my_user, expires_at: nil)

      get "/web_push_registrations", headers: @headers
      expect(response).to have_http_status(:ok)

      res = JSON.parse(response.body)
      expect(res['active_registrations_count']).to eq(3)
    end

    it 'checks if the user has active registrations, when they have expired' do
      create(:web_push_registration, user: @my_user, expires_at: Time.now - 1.day)

      get "/web_push_registrations", headers: @headers
      expect(response).to have_http_status(:ok)

      res = JSON.parse(response.body)
      expect(res['active_registrations_count']).to eq(0)
    end
  end
end
