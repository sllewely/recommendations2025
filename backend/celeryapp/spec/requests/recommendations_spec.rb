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

end
