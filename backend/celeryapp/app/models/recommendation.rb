class Recommendation < ApplicationRecord
  has_many :post_recommendations
  has_many :posts, through: :post_recommendations
  has_one :user
end
