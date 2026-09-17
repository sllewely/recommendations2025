require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#destroy" do
    it "deletes the user's post feed items when the user is destroyed" do
      user = create(:user)
      # Create a feedable object (e.g., a Post) for the feed item
      post = create(:post, user: user)
      feed_item = post.feed_item

      expect {
        user.destroy
      }.to change(FeedItem, :count).by(-1)

      expect(FeedItem.exists?(feed_item.id)).to be_falsey
    end

    it "deletes the user's event feed items when the user is destroyed" do
      user = create(:user)
      # Create a feedable object (e.g., a Post) for the feed item
      event = create(:event, user: user)
      feed_item = event.feed_item

      expect {
        user.destroy
      }.to change(FeedItem, :count).by(-1)

      expect(FeedItem.exists?(feed_item.id)).to be_falsey
    end

    it "deletes the user's recommendation feed items when the user is destroyed" do
      user = create(:user)
      # Create a feedable object (e.g., a Post) for the feed item
      recommendation = create(:recommendation, user: user)
      feed_item = recommendation.feed_item

      expect {
        user.destroy
      }.to change(FeedItem, :count).by(-1)

      expect(FeedItem.exists?(feed_item.id)).to be_falsey
    end
  end

  describe "#friend_statuses" do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }
    let(:sent_request_user) { create(:user) }
    let(:pending_request_user) { create(:user) }

    before do
      Friendship.create_bidirectional_friendship!(user, friend)
      create(:friend_request, user: sent_request_user, incoming_friend: user)
      create(:friend_request, user: user, incoming_friend: pending_request_user)
    end

    it "always returns :self for the user themselves" do
      statuses = user.friend_statuses
      expect(statuses[user.id]).to eq(:self)
      expect(statuses[friend.id]).to eq(:friends)
      expect(statuses[sent_request_user.id]).to eq(:sent_friend_request)
      expect(statuses[pending_request_user.id]).to eq(:pending_friend_request)
    end

    it "always returns :self even if there were any self requests or overlapping ids" do
      # Simulate a self friend request row in DB bypassing validator
      fr = build(:friend_request, user: user, incoming_friend: user)
      fr.save(validate: false)
      statuses = user.friend_statuses
      expect(statuses[user.id]).to eq(:self)
      expect(user.friend_status(user.id)).to eq(:self)
    end
  end
end
