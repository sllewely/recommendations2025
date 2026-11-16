# a guest's vote for a proposed time
class ProposedTimeGuest < ApplicationRecord
  self.table_name = "proposed_times_guests"

  belongs_to :proposed_time
  belongs_to :guest

  validates :guest_id, uniqueness: { scope: :proposed_time_id }
end
