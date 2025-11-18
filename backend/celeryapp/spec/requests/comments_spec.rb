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
      expect(res['body']).to eq('hoo boy I sure love stew')
      expect(res['commentable_id']).to eq(event.id)
    end

    it 'creates a comment on a post' do
      post1 = create(:post)

      post "/comments", params: { body: 'hoo boy I sure love stew', commentable_id: post1.id, commentable_type: "Post" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['body']).to eq('hoo boy I sure love stew')
      expect(res['commentable_id']).to eq(post1.id)
    end

    it 'creates a comment on a recommendation' do
      recommendation = create(:recommendation)

      post "/comments", params: { body: 'hoo boy I sure love stew', commentable_id: recommendation.id, commentable_type: "Recommendation" }, headers: @headers

      expect(response).to have_http_status(:created)
      res = JSON.parse(response.body)
      expect(res['body']).to eq('hoo boy I sure love stew')
      expect(res['commentable_id']).to eq(recommendation.id)
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

  end
end

