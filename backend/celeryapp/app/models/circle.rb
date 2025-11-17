class Circle < ApplicationRecord
  belongs_to :user
  has_many :user_circles
  has_many :members, through: :user_circles, class_name: 'User'
end