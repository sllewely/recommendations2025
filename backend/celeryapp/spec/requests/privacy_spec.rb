require 'rails_helper'
require 'json'

RSpec.describe "Privacy", type: :request do
  def sign_in_headers(user)
    post "/sign_in", params: { email: user.email, password: user.password }, headers: { 'ACCEPT' => 'application/json' }
    auth_token = JSON.parse(response.body)["auth_token"]
    { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
  end

  let(:me) { create(:user) }
  let(:friend) { create(:user) }
  let(:stranger) { create(:user) }
  let(:headers) { sign_in_headers(me) }

  before do
    Friendship.create_bidirectional_friendship!(me, friend)
  end

  def shared(feedable, visibility, user_ids: [], circle_ids: [])
    feedable.apply_privacy!(visibility: visibility, user_ids: user_ids, circle_ids: circle_ids)
    feedable
  end

  describe "GET /posts" do
    it "only returns feed items I can see" do
      public_post = shared(create(:post, user: friend), "public")
      friends_post = shared(create(:post, user: friend), "friends")
      stranger_friends_post = shared(create(:post, user: stranger), "friends")
      hidden_post = shared(create(:post, user: friend), "specific")
      shared_with_me = shared(create(:post, user: friend), "specific", user_ids: [me.id])
      circle = create(:circle, user: friend, members: [me])
      via_circle = shared(create(:post, user: friend), "specific", circle_ids: [circle.id])
      own_private = shared(create(:post, user: me), "specific")

      get "/posts", headers: headers

      expect(response).to have_http_status(:ok)
      ids = JSON.parse(response.body)["feed_items"].map { |f| f["feedable"]["id"] }
      expect(ids).to contain_exactly(public_post.id, friends_post.id, shared_with_me.id, via_circle.id, own_private.id)
      expect(ids).not_to include(stranger_friends_post.id, hidden_post.id)
    end

    it "only shows privacy settings to the owner" do
      mine = shared(create(:post, user: me), "specific", user_ids: [friend.id])
      theirs = shared(create(:post, user: friend), "public")

      get "/posts", headers: headers

      feedables = JSON.parse(response.body)["feed_items"].map { |f| f["feedable"] }
      my_json = feedables.find { |f| f["id"] == mine.id }
      their_json = feedables.find { |f| f["id"] == theirs.id }
      expect(my_json["visibility"]).to eq("specific")
      expect(my_json["audience"]).to eq([{ "type" => "user", "id" => friend.id, "name" => friend.name }])
      expect(their_json).not_to have_key("visibility")
      expect(their_json).not_to have_key("audience")
    end
  end

  describe "GET /posts/:id" do
    it "returns 404 when I can't see the post" do
      post_record = shared(create(:post, user: friend), "specific")

      get "/posts/#{post_record.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it "returns the post when I'm in the audience" do
      post_record = shared(create(:post, user: friend), "specific", user_ids: [me.id])

      get "/posts/#{post_record.id}", headers: headers

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /posts" do
    it "defaults to public" do
      post "/posts", params: { content: "hello" }, headers: headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res["visibility"]).to eq("public")
      expect(Post.find(res["id"]).feed_item.visibility).to eq("public")
    end

    it "saves a specific audience and only notifies people who can see it" do
      other_friend = create(:user)
      Friendship.create_bidirectional_friendship!(me, other_friend)
      circle = create(:circle, user: me, members: [other_friend])
      excluded_friend = create(:user)
      Friendship.create_bidirectional_friendship!(me, excluded_friend)

      post "/posts", params: {
        content: "secret",
        privacy: "specific",
        privacy_user_ids: [friend.id],
        privacy_circle_ids: [circle.id],
      }, headers: headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res["visibility"]).to eq("specific")
      expect(res["audience"].map { |a| a["id"] }).to contain_exactly(friend.id, circle.id)

      expect(friend.notifications.count).to eq(1)
      expect(other_friend.notifications.count).to eq(1)
      expect(excluded_friend.notifications.count).to eq(0)
    end

    it "rejects sharing with someone who isn't my friend" do
      post "/posts", params: { content: "secret", privacy: "specific", privacy_user_ids: [stranger.id] }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(Post.where(content: "secret")).to be_empty
    end

    it "rejects sharing with someone else's circle" do
      circle = create(:circle, user: friend)
      post "/posts", params: { content: "secret", privacy: "specific", privacy_circle_ids: [circle.id] }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "rejects an unknown privacy value" do
      post "/posts", params: { content: "secret", privacy: "everyone" }, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /posts/:id" do
    it "replaces the audience" do
      other_friend = create(:user)
      Friendship.create_bidirectional_friendship!(me, other_friend)
      post_record = shared(create(:post, user: me), "specific", user_ids: [friend.id])

      patch "/posts/#{post_record.id}", params: { privacy: "specific", privacy_user_ids: [other_friend.id] }, headers: headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res["audience"].map { |a| a["id"] }).to eq([other_friend.id])
    end

    it "clears the audience when switching to friends" do
      post_record = shared(create(:post, user: me), "specific", user_ids: [friend.id])

      patch "/posts/#{post_record.id}", params: { privacy: "friends" }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(post_record.feed_item.reload.visibility).to eq("friends")
      expect(post_record.feed_item.feed_item_audiences).to be_empty
    end

    it "keeps the privacy when none is sent" do
      post_record = shared(create(:post, user: me), "friends")

      patch "/posts/#{post_record.id}", params: { title: "new title" }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(post_record.feed_item.reload.visibility).to eq("friends")
    end
  end

  describe "GET /recommendations" do
    it "filters a user's recommendations by what I can see" do
      visible = shared(create(:recommendation, user: friend), "friends")
      hidden = shared(create(:recommendation, user: friend), "specific")

      get "/recommendations", params: { user_id: friend.id }, headers: headers

      expect(response).to have_http_status(:ok)
      ids = JSON.parse(response.body)["recommendations"].map { |r| r["id"] }
      expect(ids).to include(visible.id)
      expect(ids).not_to include(hidden.id)
    end
  end

  describe "GET /recommendations/:id" do
    it "returns 404 when I can't see the recommendation" do
      recommendation = shared(create(:recommendation, user: stranger), "friends")

      get "/recommendations/#{recommendation.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /recommendations" do
    it "saves the privacy and only notifies people who can see it" do
      post "/recommendations", params: { title: "Annihilation", privacy: "specific" }, headers: headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res["visibility"]).to eq("specific")
      expect(friend.notifications.count).to eq(0)
    end
  end

  describe "PATCH /recommendations/:id" do
    it "updates the privacy" do
      recommendation = create(:recommendation, user: me)

      patch "/recommendations/#{recommendation.id}", params: { privacy: "specific", privacy_user_ids: [friend.id] }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(recommendation.feed_item.reload.visibility).to eq("specific")
      expect(Recommendation.visible_to(friend)).to include(recommendation)
      expect(Recommendation.visible_to(stranger)).not_to include(recommendation)
    end
  end
end
