require 'rails_helper'
require 'json'

RSpec.describe "Reactions", type: :request do
  describe 'update' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates a reaction on a post' do
      post1 = create(:post)

      post "/reactions", params: { react: 'like', reactable_type: 'Post', reactable_id: post1.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['react']).to eq('like')
      expect(res['reactable_type']).to eq('Post')
      expect(res['reactable_id']).to eq(post1.id)

      expect(post1.reactions.size).to eq(1)
    end

    it 'updates a reaction on a post' do
      post1 = create(:post)
      react1 = create(:reaction, react: 'like', reactable: post1, user: @my_user)

      post "/reactions", params: { id: react1.id, react: 'heart', reactable_type: 'Post', reactable_id: post1.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['react']).to eq('heart')
      expect(res['id']).to eq(react1.id)
    end

    it 'i cannot edit someone elses reaction' do
      post1 = create(:post)
      react1 = create(:reaction, react: 'like', reactable: post1)

      post "/reactions", params: { id: react1.id, react: 'heart', reactable_type: 'Post', reactable_id: post1.id }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
    end

  end
end