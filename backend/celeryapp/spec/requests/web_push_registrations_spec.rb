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

      @my_user.web_push_registrations.reload
      expect(@my_user.web_push_registrations.count).to eq(1)
    end
  end
end
