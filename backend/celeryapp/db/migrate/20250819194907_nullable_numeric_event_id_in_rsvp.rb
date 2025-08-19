class NullableNumericEventIdInRsvp < ActiveRecord::Migration[8.0]
  def change
    change_column Rsvp.table_name, :numeric_event_id, :integer, null: true
  end
end
