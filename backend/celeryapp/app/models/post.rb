class Post < ApplicationRecord
  has_many :post_recommendations
  has_many :recommendations, through: :post_recommendations
  belongs_to :user

  accepts_nested_attributes_for :recommendations

  def attributes
    super.merge(
      { recommendations: recommendations,
        user: user.public_attributes,
      })
  end

end
