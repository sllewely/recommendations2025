class ProposedTime < ApplicationRecord
  belongs_to :event
  has_many :proposed_time_users, dependent: :destroy
  has_many :users, through: :proposed_time_users

  validates :start_date_time, presence: true
end
