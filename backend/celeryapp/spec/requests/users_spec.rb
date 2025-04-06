require 'rails_helper'
require 'json'

RSpec.describe "User", type: :request do

  describe "GET /users/[:id]" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    let(:other_user) { create(:user) }

    it 'shows fields when I view myself' do
      get "/users/#{@my_user.id}", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['username']).to eq(@my_user.username)
      expect(res['name']).to eq(@my_user.name)
      expect(res['id']).to eq(@my_user.id)
      expect(res['verified']).to eq(@my_user.verified)
      expect(res['email']).to eq(@my_user.email)
    end

    it 'shows my friendcode I view myself' do
      get "/users/#{@my_user.id}", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['friend_code']).to_not be_nil
      expect(res['friend_code']).to_not eq('')
      expect(res['friend_code']).to eq(@my_user.friend_code)
    end

    it 'shows limited fields when I view someone else' do
      get "/users/#{other_user.id}", headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['username']).to eq(other_user.username)
      expect(res['name']).to eq(other_user.name)
      expect(res['id']).to eq(other_user.id)
      expect(res['verified']).to be_nil
      expect(res['email']).to be_nil
    end

    it 'fails if the user does not exist' do
      get "/users/1234567790", headers: @headers

      expect(response).to have_http_status(:not_found)
      res = JSON.parse(response.body)
      expect(res['name']).to be_nil
      expect(res['id']).to be_nil
    end
  end

  describe "PUT /users/:id" do
    before(:context) do
      @my_update_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_update_user.email, password: @my_update_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @update_headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'updates my name' do
      put "/users/#{@my_update_user.id}", params: { name: "New Name" }, headers: @update_headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res['name']).to eq("New Name")
    end

    it 'cannot update someone else' do
      other_user = create(:user)
      put "/users/#{other_user.id}", params: { name: "New Name" }, headers: @update_headers

      expect(response).to have_http_status(:unauthorized)
    end

  end

end
