class UserCircle < ApplicationRecord
  belongs_to :user
  belongs_to :circle
end