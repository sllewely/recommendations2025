class RenameColumnUserIdToMemberIdInUserCircle < ActiveRecord::Migration[8.1]
  def change
    rename_column :user_circles, :user_id, :member_id
  end
end
