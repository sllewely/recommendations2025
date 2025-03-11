class PostRecommendation < ApplicationRecord
  belongs_to :post
  belongs_to :recommendation
end
