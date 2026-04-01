class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users

  before_save :convert_lowercase

  def convert_lowercase
    self.name = self.name.downcase.strip
  end
end
