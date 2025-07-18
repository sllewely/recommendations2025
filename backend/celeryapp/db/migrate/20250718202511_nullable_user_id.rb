class NullableUserId < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :numeric_id, :bigint, default: 0, null: true
  end
end
