class Circle < ApplicationRecord
  belongs_to :user
  has_many :user_circles, dependent: :destroy
  has_many :members, through: :user_circles, class_name: 'User'

  validates :name, presence: true
  validates :members, presence: true
end