require 'rails_helper'
require 'json'

RSpec.describe "Events", type: :request do
  describe 'create' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates an event' do

      post "/events", params: { title: 'k flay', description: "come see this fun show with me", start_date_time: DateTime.now + 5.days, }, headers: @headers

      expect(response).to have_http_status(:created)

    end
  end
end