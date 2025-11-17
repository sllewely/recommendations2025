class UserCircle < ApplicationRecord
  belongs_to :member, class_name: 'User'
  belongs_to :circle
end