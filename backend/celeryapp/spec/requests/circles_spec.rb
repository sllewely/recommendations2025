require 'rails_helper'

RSpec.describe "Circles", type: :request do
  before(:context) do
    @my_user = create(:user)

    headers = { 'ACCEPT' => 'application/json' }
    post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

    auth_token = JSON.parse(response.body)["auth_token"]
    @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
  end

  describe "GET /circles" do
    it 'gets all my circles' do
      create(:circle, user: @my_user)
      create(:circle, user: @my_user)
      get '/circles', headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(2)
    end
  end

  describe "POST /circles" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'fails to create a circle without a name' do
      u1 = create(:user)
      post "/circles", params: { member_ids: [u1.id] }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to include("name")
    end

    it 'creates a circle with users' do
      u1 = create(:user)
      u2 = create(:user)
      u3 = create(:user)
      post "/circles", params: { name: "my circle", member_ids: [u1.id, u2.id, u3.id] }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['members'].size).to eq(3)
    end
  end

  describe "POST /circles/:id/add" do
    it 'adds a user to a circle' do
      u1 = create(:user)
      u2 = create(:user)
      circle = create(:circle, user: @my_user, members: [u1])

      post "/circles/#{circle.id}/add", params: { user_id: u2.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['members'].map { |m| m['id'] }).to match_array([u1.id, u2.id])
    end

    it 'returns 404 if circle not found' do
      u = create(:user)
      post "/circles/non-existent-id/add", params: { user_id: u.id }, headers: @headers

      expect(response).to have_http_status(:not_found)
    end

    it 'returns 404 if user not found' do
      u = create(:user)
      circle = create(:circle, user: @my_user, members: [u])

      post "/circles/#{circle.id}/add", params: { user_id: 'non-existent-user' }, headers: @headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /circles/:id/remove" do
    it 'removes a user from a circle' do
      u1 = create(:user)
      u2 = create(:user)
      circle = create(:circle, user: @my_user, members: [u1, u2])

      post "/circles/#{circle.id}/remove", params: { user_id: u1.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['members'].map { |m| m['id'] }).to eq([u2.id])
      expect(circle.reload.members).to eq([u2])
    end

    it 'returns 404 if circle not found' do
      u = create(:user)
      post "/circles/non-existent-id/remove", params: { user_id: u.id }, headers: @headers

      expect(response).to have_http_status(:not_found)
    end

    it 'returns 404 if circle belongs to another user' do
      other_user = create(:user)
      u = create(:user)
      other_circle = create(:circle, user: other_user, members: [u])

      post "/circles/#{other_circle.id}/remove", params: { user_id: u.id }, headers: @headers

      expect(response).to have_http_status(:not_found)
    end

    it 'returns 404 if user not found' do
      u = create(:user)
      circle = create(:circle, user: @my_user, members: [u])

      post "/circles/#{circle.id}/remove", params: { user_id: 'non-existent-user' }, headers: @headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /circles/:id" do
    it 'deletes a circle' do
      u = create(:user)
      circle = create(:circle, user: @my_user, members: [u])

      delete "/circles/#{circle.id}", headers: @headers

      expect(response).to have_http_status(:no_content)
      expect(Circle.find_by_id(circle.id)).to be_nil
    end

    it 'returns 404 if circle not found' do
      delete "/circles/non-existent-id", headers: @headers

      expect(response).to have_http_status(:not_found)
    end

    it 'returns 404 when trying to delete another users circle' do
      other_user = create(:user)
      u = create(:user)
      other_circle = create(:circle, user: other_user, members: [u])

      delete "/circles/#{other_circle.id}", headers: @headers

      expect(response).to have_http_status(:not_found)
      expect(Circle.find_by_id(other_circle.id)).to be_present
    end
  end
end
