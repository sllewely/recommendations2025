class MigrateEventIsPublicToVisibility < ActiveRecord::Migration[8.1]
  def up
    # every event gets a feed item (private events previously had none)
    execute <<~SQL
      INSERT INTO feed_items (id, user_id, feedable_type, feedable_id, visibility, created_at, updated_at)
      SELECT gen_random_uuid(), e.user_id, 'Event', e.id, 0, e.created_at, e.created_at
      FROM events e
      WHERE NOT EXISTS (
        SELECT 1 FROM feed_items fi WHERE fi.feedable_type = 'Event' AND fi.feedable_id = e.id)
    SQL

    # is_public -> public (0), otherwise specific (2)
    execute <<~SQL
      UPDATE feed_items fi
      SET visibility = CASE WHEN e.is_public THEN 0 ELSE 2 END
      FROM events e
      WHERE fi.feedable_type = 'Event' AND fi.feedable_id = e.id
    SQL

    # invited / rsvp'd users become the audience of private events
    execute <<~SQL
      INSERT INTO feed_item_audiences (id, feed_item_id, user_id, created_at, updated_at)
      SELECT DISTINCT ON (fi.id, r.user_id) gen_random_uuid(), fi.id, r.user_id, NOW(), NOW()
      FROM feed_items fi
      JOIN events e ON fi.feedable_type = 'Event' AND fi.feedable_id = e.id
      JOIN rsvps r ON r.event_id = e.id
      WHERE e.is_public IS NOT TRUE AND r.user_id <> e.user_id
      ON CONFLICT DO NOTHING
    SQL

    remove_index :events, :is_public
    remove_column :events, :is_public
  end

  def down
    add_column :events, :is_public, :boolean, default: false
    add_index :events, :is_public

    execute <<~SQL
      UPDATE events e
      SET is_public = (fi.visibility = 0)
      FROM feed_items fi
      WHERE fi.feedable_type = 'Event' AND fi.feedable_id = e.id
    SQL
  end
end
