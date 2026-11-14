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
      expect(res['email']).to eq(@my_user.email)
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

  describe "PATCH /users/:id" do
    before(:context) do
      @my_update_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_update_user.email, password: @my_update_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @update_headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'updates my name' do
      patch "/users/#{@my_update_user.id}", params: { name: "New Name" }, headers: @update_headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res['name']).to eq("New Name")
    end

    it 'adds tags' do
      skip "remove tags feature for now for n+1 queries"
      patch "/users/#{@my_update_user.id}", params: { tags: ['recurse', 'gangout'] }, headers: @update_headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res['tags']).to eq(['recurse', 'gangout'])
    end

    it 'cannot update someone else' do
      other_user = create(:user)
      patch "/users/#{other_user.id}", params: { name: "New Name" }, headers: @update_headers

      expect(response).to have_http_status(:unauthorized)
    end

  end

  describe "GET /users/" do
    before(:context) do
      # users created in before(:contexts) may persist
      User.destroy_all

      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'gets user matching search query' do
      create(:user, name: "tom harp")
      create(:user, name: "thom sharp")
      create(:user, name: "tomathy barp")
      create(:user, name: "Tommy harpy")

      get "/users/?search=Tom", headers: @headers
      res = JSON.parse(response.body)

      expect(res.size).to eq(3)
    end

    it 'gets user matching search query' do
      create(:user, name: "tom harp")
      create(:user, name: "thom sharp")
      create(:user, name: "tomathy barp")
      create(:user, name: "Tommy harpy")

      get "/users/?search=Tom", headers: @headers
      res = JSON.parse(response.body)

      expect(res.size).to eq(3)
    end

    it 'gets user matching tags' do
      tag_user1 = create(:user, name: "tom harp")
      tag_user1.update_tags(['nyc', 'recurse'])
      tag_user2 = create(:user, name: "thom sharp")
      tag_user2.update_tags(['nyc'])
      tag_user3 = create(:user, name: "tomathy barp")
      tag_user3.update_tags(['recurse'])
      tag_user4 = create(:user, name: "Tommy harpy")

      get "/users/?tag=nyc", headers: @headers
      res = JSON.parse(response.body)

      expect(res.size).to eq(2)
    end

    it 'gets user matching search query' do
      create(:user, name: "tom harp")
      create(:user, name: "thom sharp")
      create(:user, name: "tomathy barp")
      create(:user, name: "Tommy harpy")

      get "/users/?search=arp", headers: @headers
      res = JSON.parse(response.body)

      # 4 or 5 cuz sometimes the current user matches
      expect(res.size).to eq(4) or eq(5)
    end

  end

end
