class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups

  before_save :convert_lowercase

  def convert_lowercase
    self.name = self.name.downcase.strip
  end
end
