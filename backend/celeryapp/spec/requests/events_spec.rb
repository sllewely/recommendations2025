require 'rails_helper'
require 'json'

RSpec.describe "Events", type: :request do

  describe 'create' do

    before(:all) do
      @email = 'test@gmail.com'
      @password = 'testtesttest77'
      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_up", params: { email: @email, password: @password, password_confirmation: @password }, headers: headers

    end

    it 'auth is working' do
      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @email, password: @password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]

      headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
      post "/events", headers: headers

      expect(response).to have_http_status(:created)

    end

  end

end