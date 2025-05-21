class UserStatus < ApplicationRecord
  belongs_to :user
  validates :status, presence: true, allow_blank: false
end
