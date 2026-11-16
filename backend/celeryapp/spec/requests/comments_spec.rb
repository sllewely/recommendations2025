require 'rails_helper'
require 'json'

RSpec.describe "Comments", type: :request do
  describe 'create' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'creates a comment on an event' do
      event = create(:event)

      post "/comments", params: { body: 'hoo boy I sure love stew', commentable_id: event.id, commentable_type: "Event" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res.size).to eq(1)
      expect(res[0]['body']).to eq('hoo boy I sure love stew')
      expect(res[0]['commentable_id']).to eq(event.id)
    end

    it 'creates a comment on a post' do
      post1 = create(:post)

      post "/comments", params: { body: 'hoo boy I sure love stew', commentable_id: post1.id, commentable_type: "Post" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res.size).to eq(1)
      expect(res[0]['body']).to eq('hoo boy I sure love stew')
      expect(res[0]['commentable_id']).to eq(post1.id)
    end

    it 'creates a comment on a recommendation' do
      recommendation = create(:recommendation)

      post "/comments", params: { body: 'hoo boy I sure love stew', commentable_id: recommendation.id, commentable_type: "Recommendation" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res.size).to eq(1)
      expect(res[0]['body']).to eq('hoo boy I sure love stew')
      expect(res[0]['commentable_id']).to eq(recommendation.id)
    end

    it 'cant have an empty body' do
      post1 = create(:post)

      post "/comments", params: { body: '', commentable_id: post1.id, commentable_type: "Post" }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      res = JSON.parse(response.body)
      expect(res['error']).to eq("Validation failed: Body can't be blank")
    end

    it 'creates a comment and returns multiple' do
      event = create(:event)
      create(:comment, :for_event, commentable: event)
      create(:comment, :for_event, commentable: event)
      create(:comment, :for_event, commentable: event)

      post "/comments", params: { body: 'hoo boy I sure love stew', commentable_id: event.id, commentable_type: "Event" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res.size).to eq(4)
      expect(res[3]['body']).to eq('hoo boy I sure love stew')
      expect(res[3]['commentable_id']).to eq(event.id)
    end

    it 'returns reactions on comments' do
      post1 = create(:post)
      existing = create(:comment, :for_post, commentable: post1)
      create(:reaction, react: 'heart', reactable: existing)

      post "/comments", params: { body: 'hoo boy I sure love stew', commentable_id: post1.id, commentable_type: "Post" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res[0]['class_name']).to eq('Comment')
      expect(res[0]['reactions'].size).to eq(1)
      expect(res[0]['reactions'][0]['react']).to eq('heart')
      expect(res[1]['reactions']).to eq([])
    end

    it 'in app notifications are sent to people when I comment' do
      user = create(:user)
      event = create(:event, user: user)
      user2 = create(:user)
      create(:comment, :for_event, commentable: event, user: user2)
      create(:comment, :for_event, commentable: event, user: user2)
      create(:comment, :for_event, commentable: event, user: user)

      post "/comments", params: { body: 'hoo boy I sure love stew', commentable_id: event.id, commentable_type: "Event" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res.size).to eq(4)
      expect(res[3]['body']).to eq('hoo boy I sure love stew')
      expect(res[3]['commentable_id']).to eq(event.id)

      expect(user.notifications.size).to eq(1)
      expect(user.notifications.first.message).to eq("#{@my_user.name} commented on your event")
      expect(user2.notifications.size).to eq(1)
      expect(user2.notifications.first.message).to eq("#{@my_user.name} commented on a event you're following")
    end

    it 'in app notifications are sent to people when I comment' do
      user = create(:user)
      post = create(:post, user: user)
      user2 = create(:user)
      create(:comment, :for_post, commentable: post, user: user2)
      create(:comment, :for_post, commentable: post, user: user2)
      create(:comment, :for_post, commentable: post, user: user)

      post "/comments", params: { body: 'hoo boy I sure love stew', commentable_id: post.id, commentable_type: "Post" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res.size).to eq(4)
      expect(res[3]['body']).to eq('hoo boy I sure love stew')
      expect(res[3]['commentable_id']).to eq(post.id)

      expect(user.notifications.size).to eq(1)
      expect(user.notifications.first.message).to eq("#{@my_user.name} commented on your post")
      expect(user2.notifications.size).to eq(1)
      expect(user2.notifications.first.message).to eq("#{@my_user.name} commented on a post you're following")
    end
  end

  describe 'update' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'updates a comment on an event' do
      event = create(:event)
      comment = create(:comment, :for_event, commentable: event, user: @my_user)

      patch "/comments/#{comment.id}", params: { body: 'hoo boy I sure love stew' }, headers: @headers

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['body']).to eq('hoo boy I sure love stew')
    end

    it 'cant update a comment to have an empty body' do
      comment = create(:comment, :for_post, user: @my_user, body: 'original')

      patch "/comments/#{comment.id}", params: { body: '' }, headers: @headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(comment.reload.body).to eq('original')
    end

    it 'cant update someone elses comment' do
      comment = create(:comment, :for_post, body: 'original')

      patch "/comments/#{comment.id}", params: { body: 'hacked' }, headers: @headers

      expect(response).to have_http_status(:not_found)
      expect(comment.reload.body).to eq('original')
    end

  end

  describe 'destroy' do

    before(:all) do
      @my_user = create(:user)

      headers = { 'ACCEPT' => 'application/json' }
      post "/sign_in", params: { email: @my_user.email, password: @my_user.password }, headers: headers

      auth_token = JSON.parse(response.body)["auth_token"]
      @headers = { 'ACCEPT' => 'application/json', 'Authorization' => "Token #{auth_token}" }
    end

    it 'deletes my own comment' do
      comment = create(:comment, :for_post, user: @my_user)

      delete "/comments/#{comment.id}", headers: @headers

      expect(response).to have_http_status(:no_content)
      expect(Comment.find_by(id: comment.id)).to be_nil
    end

    it 'cant delete someone elses comment' do
      comment = create(:comment, :for_post)

      delete "/comments/#{comment.id}", headers: @headers

      expect(response).to have_http_status(:not_found)
      expect(Comment.find_by(id: comment.id)).not_to be_nil
    end

  end
end
