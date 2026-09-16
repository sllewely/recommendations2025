require 'rails_helper'

RSpec.describe UserBlueprint do
  let(:current_user) { create(:user) }
  let(:friend_user) { create(:user) }
  let(:sent_request_user) { create(:user) }
  let(:pending_request_user) { create(:user) }
  let(:unrelated_user) { create(:user) }

  before do
    Friendship.create_bidirectional_friendship!(current_user, friend_user)
    create(:friend_request, user: sent_request_user, incoming_friend: current_user)
    create(:friend_request, user: current_user, incoming_friend: pending_request_user)
  end

  describe "friendship_status field in :authed view" do
    context "with precomputed friend_statuses option" do
      let(:friend_statuses) { current_user.friend_statuses }

      it "returns correct friendship statuses" do
        rendered_self = JSON.parse(UserBlueprint.render(current_user, view: :authed, friend_statuses: friend_statuses))
        rendered_friend = JSON.parse(UserBlueprint.render(friend_user, view: :authed, friend_statuses: friend_statuses))
        rendered_sent = JSON.parse(UserBlueprint.render(sent_request_user, view: :authed, friend_statuses: friend_statuses))
        rendered_pending = JSON.parse(UserBlueprint.render(pending_request_user, view: :authed, friend_statuses: friend_statuses))
        rendered_unrelated = JSON.parse(UserBlueprint.render(unrelated_user, view: :authed, friend_statuses: friend_statuses))

        expect(rendered_self['friendship_status']).to eq('self')
        expect(rendered_friend['friendship_status']).to eq('friends')
        expect(rendered_sent['friendship_status']).to eq('sent_friend_request')
        expect(rendered_pending['friendship_status']).to eq('pending_friend_request')
        expect(rendered_unrelated['friendship_status']).to eq('none')
      end
    end

    context "with current_user option" do
      it "returns correct friendship statuses" do
        rendered_self = JSON.parse(UserBlueprint.render(current_user, view: :authed, current_user: current_user))
        rendered_friend = JSON.parse(UserBlueprint.render(friend_user, view: :authed, current_user: current_user))
        rendered_sent = JSON.parse(UserBlueprint.render(sent_request_user, view: :authed, current_user: current_user))
        rendered_pending = JSON.parse(UserBlueprint.render(pending_request_user, view: :authed, current_user: current_user))
        rendered_unrelated = JSON.parse(UserBlueprint.render(unrelated_user, view: :authed, current_user: current_user))

        expect(rendered_self['friendship_status']).to eq('self')
        expect(rendered_friend['friendship_status']).to eq('friends')
        expect(rendered_sent['friendship_status']).to eq('sent_friend_request')
        expect(rendered_pending['friendship_status']).to eq('pending_friend_request')
        expect(rendered_unrelated['friendship_status']).to eq('none')
      end
    end

    context "with Current.session / Current.user fallback" do
      before do
        Current.session = current_user.sessions.create!
      end

      after do
        Current.session = nil
      end

      it "returns correct friendship statuses without passing options" do
        rendered_self = JSON.parse(UserBlueprint.render(current_user, view: :authed))
        rendered_friend = JSON.parse(UserBlueprint.render(friend_user, view: :authed))
        rendered_sent = JSON.parse(UserBlueprint.render(sent_request_user, view: :authed))
        rendered_pending = JSON.parse(UserBlueprint.render(pending_request_user, view: :authed))
        rendered_unrelated = JSON.parse(UserBlueprint.render(unrelated_user, view: :authed))

        expect(rendered_self['friendship_status']).to eq('self')
        expect(rendered_friend['friendship_status']).to eq('friends')
        expect(rendered_sent['friendship_status']).to eq('sent_friend_request')
        expect(rendered_pending['friendship_status']).to eq('pending_friend_request')
        expect(rendered_unrelated['friendship_status']).to eq('none')
      end
    end

    context "when no current user is provided" do
      it "returns none" do
        rendered_unrelated = JSON.parse(UserBlueprint.render(unrelated_user, view: :authed))
        expect(rendered_unrelated['friendship_status']).to eq('none')
      end
    end
  end
end
