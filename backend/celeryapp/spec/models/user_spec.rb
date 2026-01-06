require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#destroy" do
    it "deletes the user's feed items when the user is destroyed" do
      user = create(:user)
      # Create a feedable object (e.g., a Post) for the feed item
      post = create(:post, user: user)
      feed_item = post.feed_item

      expect {
        user.destroy
      }.to change(FeedItem, :count).by(-1)

      expect(FeedItem.exists?(feed_item.id)).to be_falsey
    end
  end
end
