class RenameTableUsersCircles < ActiveRecord::Migration[8.1]
  def change
    rename_table :users_circles, :user_circles
  end
end
