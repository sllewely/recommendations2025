class RenameUserGroupsToGroupUsers < ActiveRecord::Migration[8.1]
  def change
    rename_table :user_groups, :group_users
  end
end
