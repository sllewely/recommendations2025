class AddEndDateAndPrivacyToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :end_date_time, :datetime
    add_column :events, :is_public, :boolean, default: false
    add_index :events, :start_date_time
    add_index :events, :is_public
    add_index :events, :event_type
    add_index :events, :end_date_time
  end
end
