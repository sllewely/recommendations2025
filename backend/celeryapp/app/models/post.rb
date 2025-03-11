class Post < ApplicationRecord
  has_many :post_recommendations
  has_many :recommendations, through: :post_recommendations
  belongs_to :author, class_name: 'User'

  accepts_nested_attributes_for :recommendations

end
