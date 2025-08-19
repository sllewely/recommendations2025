class RsvpIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :rsvps, [:user_id, :event_id], unique: true
    add_index :rsvps, [:event_id], unique: true
  end
end
