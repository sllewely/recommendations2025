class Tag < ApplicationRecord
  has_many :user_tags
  has_many :users, through: :user_tags

  before_save :convert_lowercase

  def convert_lowercase
    self.tag = self.tag.downcase
  end
end
