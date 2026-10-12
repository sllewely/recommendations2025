require 'rails_helper'

RSpec.describe FeedItem, type: :model do
  let(:owner) { create(:user) }
  let(:friend) { create(:user) }
  let(:stranger) { create(:user) }

  before do
    # friendships are directed: owner -> friend means friend is in owner.friends
    create(:friendship, user: owner, friend: friend)
  end

  def item_with(visibility)
    post = create(:post, user: owner)
    post.feed_item.update!(visibility: visibility)
    post.feed_item
  end

  describe ".visible_to" do
    let!(:public_item) { item_with(:public) }
    let!(:friends_item) { item_with(:friends) }
    let!(:specific_item) { item_with(:specific) }

    it "lets the owner see everything" do
      expect(FeedItem.visible_to(owner)).to contain_exactly(public_item, friends_item, specific_item)
    end

    it "lets a stranger see only public items" do
      expect(FeedItem.visible_to(stranger)).to contain_exactly(public_item)
    end

    it "lets a friend see public and friends items" do
      expect(FeedItem.visible_to(friend)).to contain_exactly(public_item, friends_item)
    end

    it "does not treat the reverse friendship direction as friends" do
      # owner friended friend, not the other way round
      friend_post = create(:post, user: friend)
      friend_post.feed_item.update!(visibility: :friends)
      expect(FeedItem.visible_to(owner)).not_to include(friend_post.feed_item)
    end

    it "lets a directly listed user see a specific item" do
      specific_item.replace_audience!(user_ids: [friend.id])
      expect(FeedItem.visible_to(friend)).to include(specific_item)
      expect(FeedItem.visible_to(stranger)).not_to include(specific_item)
    end

    it "lets a member of a listed circle see a specific item" do
      member = create(:user)
      create(:friendship, user: owner, friend: member)
      circle = create(:circle, user: owner, members: [member])
      specific_item.replace_audience!(circle_ids: [circle.id])

      expect(FeedItem.visible_to(member)).to include(specific_item)
      expect(FeedItem.visible_to(friend)).not_to include(specific_item)
    end

    it "uses live circle membership" do
      circle = create(:circle, user: owner)
      specific_item.replace_audience!(circle_ids: [circle.id])
      expect(FeedItem.visible_to(stranger)).not_to include(specific_item)

      membership = UserCircle.create!(circle: circle, member: stranger)
      expect(FeedItem.visible_to(stranger)).to include(specific_item)

      membership.destroy!
      expect(FeedItem.visible_to(stranger)).not_to include(specific_item)
    end

    it "shows a specific item with no audience only to the owner" do
      expect(FeedItem.visible_to(friend)).not_to include(specific_item)
      expect(FeedItem.visible_to(owner)).to include(specific_item)
    end
  end

  describe "#visible_to?" do
    it "matches the scope" do
      item = item_with(:friends)
      expect(item.visible_to?(owner)).to be true
      expect(item.visible_to?(friend)).to be true
      expect(item.visible_to?(stranger)).to be false
      expect(item.visible_to?(nil)).to be false
    end
  end

  describe "#replace_audience!" do
    let(:item) { item_with(:specific) }

    it "replaces the previous audience" do
      other_friend = create(:user)
      create(:friendship, user: owner, friend: other_friend)
      circle = create(:circle, user: owner)

      item.replace_audience!(user_ids: [friend.id], circle_ids: [circle.id])
      expect(item.feed_item_audiences.count).to eq 2

      item.replace_audience!(user_ids: [other_friend.id])
      expect(item.feed_item_audiences.pluck(:user_id)).to eq [other_friend.id]
      expect(item.feed_item_audiences.where.not(circle_id: nil)).to be_empty
    end

    it "rejects users who aren't friends of the owner" do
      expect { item.replace_audience!(user_ids: [stranger.id]) }.to raise_error(FeedItem::InvalidAudience)
    end

    it "rejects circles owned by someone else" do
      circle = create(:circle, user: stranger)
      expect { item.replace_audience!(circle_ids: [circle.id]) }.to raise_error(FeedItem::InvalidAudience)
    end

    it "serializes the audience" do
      member = create(:user, name: "Member")
      circle = create(:circle, user: owner, name: "Book club", members: [member])
      item.replace_audience!(user_ids: [friend.id], circle_ids: [circle.id])

      expect(item.audience).to contain_exactly(
        { type: "user", id: friend.id, name: friend.name },
        { type: "circle", id: circle.id, name: "Book club", members: ["Member"] }
      )
    end
  end

  describe "cascades" do
    it "removes audience rows when the circle is deleted" do
      item = item_with(:specific)
      circle = create(:circle, user: owner)
      item.replace_audience!(circle_ids: [circle.id])

      expect { circle.destroy! }.to change(FeedItemAudience, :count).by(-1)
    end

    it "removes audience rows when the user is deleted" do
      item = item_with(:specific)
      item.replace_audience!(user_ids: [friend.id])

      expect { friend.destroy! }.to change(FeedItemAudience, :count).by(-1)
    end
  end

  describe Feedable do
    it "scopes posts by visibility" do
      visible = create(:post, user: owner)
      hidden = create(:post, user: owner)
      hidden.apply_privacy!(visibility: "specific")

      expect(Post.visible_to(stranger)).to include(visible)
      expect(Post.visible_to(stranger)).not_to include(hidden)
      expect(hidden.visible_to?(stranger)).to be false
      expect(hidden.visible_to?(owner)).to be true
    end

    it "creates a feed item when applying privacy to an item without one" do
      event = Event.create!(user: owner, title: "Party", start_date_time: 1.day.from_now)
      event.apply_privacy!(visibility: "specific", user_ids: [friend.id])

      expect(event.feed_item.visibility).to eq "specific"
      expect(Event.visible_to(friend)).to include(event)
      expect(Event.visible_to(stranger)).not_to include(event)
    end

    it "leaves privacy unchanged when no visibility is given" do
      post = create(:post, user: owner)
      post.apply_privacy!(visibility: "specific", user_ids: [friend.id])
      post.apply_privacy!

      expect(post.feed_item.reload.visibility).to eq "specific"
      expect(post.feed_item.feed_item_audiences.count).to eq 1
    end

    it "rolls back the visibility change when the audience is invalid" do
      post = create(:post, user: owner)
      expect {
        post.apply_privacy!(visibility: "specific", user_ids: [stranger.id])
      }.to raise_error(FeedItem::InvalidAudience)
      expect(post.feed_item.reload.visibility).to eq "public"
    end
  end
end
