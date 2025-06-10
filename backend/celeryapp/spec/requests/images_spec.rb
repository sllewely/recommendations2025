require 'rails_helper'
require 'json'

RSpec.describe "Images", type: :request do

  describe "GET /upload_url" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'gets the upload url for the user' do
      get "/images/upload_url", headers: @headers

      # expect(response).to have_http_status(:ok)
      # res = JSON.parse(response.body)
      skip
    end

  end
end
