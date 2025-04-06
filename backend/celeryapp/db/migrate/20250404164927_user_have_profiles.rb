class UserHaveProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :blurb, :text
  end
end
