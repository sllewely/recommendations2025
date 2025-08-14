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

    it 'creates a new post' do
      post "/posts", params: { post_title: "new fav book", content: "I love it a lot, you should read it" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to_not be_nil
      expect(res['post_title']).to eq("new fav book")
    end

    # it 'posts must have a title' do
    #   post "/posts", params: { content: "I love it a lot, you should read it" }, headers: @headers
    #
    #   expect(response).to have_http_status(:unprocessable_content)
    #   res = JSON.parse(response.body)
    #   expect(res['exception']).to eq("#<ActiveRecord::RecordInvalid: Validation failed: Post title can't be blank>")
    # end

    it 'posts must have a title' do
      post "/posts", params: { content: "I love it a lot, you should read it" }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to eq("post_title: can't be blank")
    end

    # it 'creates a new post with a recommendation' do
    #   post "/posts", params: { post_title: "new fav book", content: "I love it a lot, you should read it", recommendations_attributes: [title: "Annihilation", notes: "A book I like"] }, headers: @headers
    #
    #   expect(response).to have_http_status(:created)
    #   res = JSON.parse(response.body)
    #   expect(res['id']).to_not be_nil
    #   expect(res['post_title']).to eq("new fav book")
    #   expect(res['recommendations'].first['title']).to eq('Annihilation')
    # end

    # it 'creates a new post with a recommendation with rating' do
    #   post "/posts", params: { post_title: "new fav book", content: "I love it a lot, you should read it", recommendations_attributes: [title: "Annihilation", notes: "A book I like", rating: 5, status: 'recommend', media_type: 'book'] }, headers: @headers
    #
    #   expect(response).to have_http_status(:created)
    #   res = JSON.parse(response.body)
    #   expect(res['id']).to_not be_nil
    #   expect(res['post_title']).to eq("new fav book")
    #   rec_res = res['recommendations'].first
    #   expect(rec_res['title']).to eq('Annihilation')
    #   expect(rec_res['rating']).to eq(5)
    #   expect(rec_res['status']).to eq('recommend')
    #   expect(rec_res['media_type']).to eq('book')
    #   expect(rec_res['notes']).to eq('A book I like')
    # end
  end

  describe "GET /posts" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }

      @friend = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, @friend)
    end

    it 'gets all posts' do
      3.times do
        create(:post, user: @friend)
      end
      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(3)
      expect(res.first['post_title']).to_not be_nil
      expect(res.first['content']).to_not be_nil
      expect(res.first['user_id']).to_not be_nil
    end

    it 'gets all posts and recommendations' do
      create(:post, user: @friend)
      create(:recommendation, user: @friend)
      create(:post, user: @my_user)

      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(3)
      expect(res.first['post_title']).to_not be_nil
      expect(res.first['content']).to_not be_nil
      expect(res.first['user_id']).to_not be_nil
      expect(res[1]['title']).to_not be_nil
      expect(res[1]['status']).to eq("interested")
    end

    it 'gets all posts, recommendations, and events' do
      create(:post, user: @friend)
      create(:recommendation, user: @friend)
      create(:event, user: @friend)
      create(:post, user: @my_user)

      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(4)
      expect(res.first['post_title']).to_not be_nil
      expect(res.first['content']).to_not be_nil
      expect(res.first['user_id']).to_not be_nil
      expect(res[2]['title']).to_not be_nil
      expect(res[2]['status']).to eq("interested")
    end

    it 'gets events' do
      create(:event, user: @friend)
      create(:event, user: @my_user)

      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(2)
      expect(res[0]['title']).to_not be_nil
      expect(res[0]['description']).to_not be_nil
      expect(res[0]['user_id']).to_not be_nil
      expect(res[0]['creator_name']).to_not be_nil
      expect(res[0]['address']).to_not be_nil
      expect(res[0]['url']).to_not be_nil
      expect(res[0]['start_date_time']).to_not be_nil
      expect(res[0]['user']['username']).to_not be_nil
      expect(res[0]['user']['name']).to_not be_nil
      expect(res[0]['class_name']).to eq('Event')
    end

    it 'gets posts with comments' do
      post1 = create(:post, user: @friend)
      create(:comment, :for_post, commentable: post1, user: @my_user)
      create(:comment, :for_post, commentable: post1, user: @friend)

      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(1)
      expect(res[0]['comments'].size).to eq(2)
      expect(res[0]['comments'][0]['body']).to_not be_nil
    end

  end

  describe "GET /posts/:id" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }

      @friend = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, @friend)
    end

    it 'gets the post' do
      post = create(:post, user: @friend)
      get "/posts/#{post.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['post_title']).to_not be_nil
      expect(res['content']).to_not be_nil
      expect(res['creator_id']).to_not be_nil
    end

    it 'gets the post with comments' do
      post1 = create(:post, user: @friend)
      create(:comment, :for_post, commentable: post1, user: @my_user)
      create(:comment, :for_post, commentable: post1, user: @friend)

      get "/posts/#{post1.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['post_title']).to_not be_nil
      expect(res['content']).to_not be_nil
      expect(res['creator_id']).to_not be_nil

      expect(res['comments'].size).to eq(2)
    end

    it 'will not return the post if not friends' do
      skip "not filtering by friends for now"
      post1 = create(:post)

      get "/posts/#{post1.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:not_found)
      res = JSON.parse(response.body)
      expect(res['error']).to eq('post not found')
    end

  end

  describe "POST /posts/:id" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'updates the post' do
      post = create(:post, user: @my_user)
      patch "/posts/#{post.id}", params: { post_title: "beep boop" }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['post_title']).to eq("beep boop")
      expect(res['content']).to eq(post.content)
      expect(res['creator_id']).to_not be_nil
    end

  end

end
