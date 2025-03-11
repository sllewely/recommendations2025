require 'rails_helper'
require 'json'

RSpec.describe "Posts", type: :request do
  describe "POST /posts" do

    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates a new post with a recommendation' do
      post "/posts", params: { post_title: "new fav book", content: "I love it a lot, you should read it", recommendations: [title: "Annihilation", description: "A book I like"] }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to_not be_nil
      expect(res['post_title']).to eq("new fav book")
    end
  end

end
