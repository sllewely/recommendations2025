class CreateUserGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :user_groups do |t|
      t.timestamps
      t.references :user, null: false, type: :uuid, foreign_key: true
      t.references :group, null: false, type: :uuid, foreign_key: true
    end

    add_index :user_groups, [:user_id, :group_id], unique: true
  end
end
