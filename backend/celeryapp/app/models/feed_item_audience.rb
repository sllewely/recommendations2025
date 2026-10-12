class FeedItemAudience < ApplicationRecord
  belongs_to :feed_item
  belongs_to :user, optional: true
  belongs_to :circle, optional: true

  validate :exactly_one_grantee

  private

  def exactly_one_grantee
    errors.add(:base, "must have exactly one of user or circle") unless user_id.present? ^ circle_id.present?
  end
end
