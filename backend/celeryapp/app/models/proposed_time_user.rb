# a user's vote for a proposed time
class ProposedTimeUser < ApplicationRecord
  self.table_name = "proposed_times_users"

  belongs_to :proposed_time
  belongs_to :user

  validates :user_id, uniqueness: { scope: :proposed_time_id }
end
