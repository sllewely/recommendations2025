class NullableEventNumericId < ActiveRecord::Migration[8.0]
  def change
    change_column :events, :numeric_id, :bigint, default: 0, null: true
  end
end
