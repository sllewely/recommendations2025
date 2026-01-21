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
      post "/posts", params: { title: "new fav book", content: "I love it a lot, you should read it" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to_not be_nil
      expect(res['content']).to eq("I love it a lot, you should read it")
    end

    it 'posts must have a body' do
      post "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to eq("content: can't be blank")
    end

    it 'sends a notification to my friends' do
      friend = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, friend)

      post "/posts", params: { content: "I love it a lot, you should read it" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['id']).to_not be_nil
      expect(res['content']).to eq("I love it a lot, you should read it")

      expect(friend.notifications.size).to eq(1)
      expect(friend.notifications.first.message).to eq("#{@my_user.name} created a new post")
    end

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
      expect(res.size).to eq(2)
      feed_items_res = res['feed_items']
      expect(feed_items_res.size).to eq(3)
      expect(feed_items_res.first["feedable"]['title']).to_not be_nil
      expect(feed_items_res.first["feedable"]['content']).to_not be_nil
      expect(feed_items_res.first["feedable"]['user']['id']).to_not be_nil
    end

    it 'wont show posts from my not-friend' do
      user = create(:user)
      3.times do
        create(:post, user: user)
      end
      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res.size).to eq(2)
      feed_items_res = res['feed_items']
      expect(feed_items_res.size).to eq(0)
    end

    it 'gets all posts and recommendations' do
      create(:post, user: @friend)
      create(:recommendation, user: @friend)
      create(:post, user: @my_user)

      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      feed_items_res = res['feed_items']
      expect(feed_items_res.size).to eq(3)
      expect(feed_items_res.first["feedable"]['title']).to_not be_nil
      expect(feed_items_res.first["feedable"]['content']).to_not be_nil
      expect(feed_items_res.first["feedable"]['user']['id']).to_not be_nil
      expect(feed_items_res[1]["feedable"]['title']).to_not be_nil
      expect(feed_items_res[1]["feedable"]['status']).to eq("interested")
    end

    it 'gets all posts, recommendations, and events' do
      create(:post, user: @friend)
      create(:recommendation, user: @friend)
      create(:event, user: @friend)
      create(:post, user: @my_user)

      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      feed_items_res = res['feed_items']
      expect(feed_items_res.size).to eq(4)
      expect(feed_items_res.first["feedable"]['title']).to_not be_nil
      expect(feed_items_res.first["feedable"]['content']).to_not be_nil
      expect(feed_items_res.first["feedable"]['user']['id']).to_not be_nil
      expect(feed_items_res[2]["feedable"]['title']).to_not be_nil
      expect(feed_items_res[2]["feedable"]['status']).to eq("interested")
    end

    it 'gets events' do
      create(:event, user: @friend)
      create(:event, user: @my_user)

      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      feed_items_res = res['feed_items']
      expect(feed_items_res.size).to eq(2)
      first_post = feed_items_res[0]["feedable"]
      expect(first_post['title']).to_not be_nil
      expect(first_post['description']).to_not be_nil
      expect(first_post['user_id']).to_not be_nil
      expect(first_post['address']).to_not be_nil
      expect(first_post['url']).to_not be_nil
      expect(first_post['start_date_time']).to_not be_nil
      expect(first_post['user']['name']).to_not be_nil
      expect(first_post['class_name']).to eq('Event')
    end

    it 'gets posts with comments' do
      post1 = create(:post, user: @friend)
      create(:comment, :for_post, commentable: post1, user: @my_user)
      create(:comment, :for_post, commentable: post1, user: @friend)

      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      feed_items_res = res['feed_items']
      expect(feed_items_res.size).to eq(1)
      expect(feed_items_res[0]["feedable"]['comments'].size).to eq(2)
      expect(feed_items_res[0]["feedable"]['comments'][0]['body']).to_not be_nil
    end

    it 'paginates' do
      create(:post, user: @friend)
      create(:recommendation, user: @friend)
      create(:post, user: @my_user)
      create(:post, user: @friend)
      create(:post, user: @friend)
      create(:event, user: @friend)
      15.times do
        create(:post, user: @friend)
        create(:event, user: @friend)
      end

      get "/posts", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      feed_items_res = res['feed_items']
      expect(feed_items_res.size).to eq(30)
      expect(res['pagy']['next']).to eq(2)

      get "/posts?page=2", params: {}, headers: @headers
      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      feed_items_res = res['feed_items']
      expect(feed_items_res.size).to eq(6)
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
      expect(res['title']).to_not be_nil
      expect(res['content']).to_not be_nil
      expect(res['user']).to_not be_nil
      expect(res['user']['id']).to_not be_nil
    end

    it 'gets the post with comments' do
      post1 = create(:post, user: @friend)
      create(:comment, :for_post, commentable: post1, user: @my_user)
      create(:comment, :for_post, commentable: post1, user: @friend)

      get "/posts/#{post1.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['title']).to_not be_nil
      expect(res['content']).to_not be_nil
      expect(res['user']).to_not be_nil
      expect(res['user']['id']).to_not be_nil

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

  describe "PATCH /posts/:id" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'updates the post' do
      post = create(:post, user: @my_user)
      patch "/posts/#{post.id}", params: { title: "beep boop" }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['title']).to eq("beep boop")
      expect(res['content']).to eq(post.content)
      expect(res['user']['name']).to_not be_nil
    end

  end

  describe "DELETE /posts/:id" do
    before(:context) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }

      @friend = create(:user)
      Friendship.create_bidirectional_friendship!(@my_user, @friend)
    end

    it 'deletes my post' do
      p = create(:post, user: @my_user)

      delete "/posts/#{p.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:no_content)
      deleted_post = Post.find_by(id: p.id)
      expect(deleted_post).to be_nil
    end

    it 'deleting my post deletes the feed item' do
      post "/posts", params: { title: "new fav book", content: "I love it a lot, you should read it" }, headers: @headers
      res = JSON.parse(response.body)
      post_id = res['id']

      delete "/posts/#{post_id}", params: {}, headers: @headers

      expect(FeedItem.where(feedable_id: post_id, feedable_type: "Post")).to be_empty

      expect(response).to have_http_status(:no_content)
      deleted_post = Post.find_by(id: post_id)
      expect(deleted_post).to be_nil
    end

    it 'cannot delete someone elses post' do
      p = create(:post, user: @friend)

      delete "/posts/#{p.id}", params: {}, headers: @headers

      expect(response).to have_http_status(:not_found)
      deleted_post = Post.find_by(id: p.id)
      expect(deleted_post).to_not be_nil
    end

    it 'delete post' do
      my_post = create(:post, user: @my_user)
      delete "/posts/#{my_post.id}", headers: @headers
      expect(response).to have_http_status(:no_content)
    end

    it "error if deleting other person's post" do
      new_user = create(:user)
      my_post = create(:post, user: new_user)
      delete "/posts/#{my_post.id}", params: {}, headers: @headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
