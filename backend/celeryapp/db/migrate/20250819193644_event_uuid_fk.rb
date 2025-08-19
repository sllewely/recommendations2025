class EventUuidFk < ActiveRecord::Migration[8.0]
  def up
    rename_column Rsvp.table_name, :event_id, :numeric_event_id
    add_column Rsvp.table_name, :event_id, :uuid
  end

  def down
    remove_column Rsvp.table_name, :event_id
    rename_column Rsvp.table_name, :numeric_event_id, :event_id
  end
end
