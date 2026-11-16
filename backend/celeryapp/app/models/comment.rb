class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :reactions, as: :reactable, dependent: :destroy

  validates :body, presence: true
end
