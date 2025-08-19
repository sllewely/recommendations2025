class PopulateEventUuidInRsvp < ActiveRecord::Migration[8.0]
  def up
    # map for reassigning ids
    events = Event.all.each_with_object({}) do |event, hash|
      hash[event.numeric_id] = event.id
    end

    Rsvp.all.each do |rsvp|
      rsvp.update(event_id: events[rsvp.numeric_event_id])
    end
    add_foreign_key Rsvp.table_name, :events, column: :event_id, on_delete: :cascade
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'This migration cannot be reverted because column renaming needs to happen first.'
  end
end
