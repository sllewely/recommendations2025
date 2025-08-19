class PointToEventUuid < ActiveRecord::Migration[8.0]
  def up
    # Only RSVPs point to event id
    remove_foreign_key Rsvp.table_name, column: :event_id

    rename_column :events, :id, :numeric_id
    rename_column :events, :uuid, :id

    change_pk(:events)
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'This migration cannot be reverted because column renaming needs to happen first.'
  end

  def change_pk(table)
    execute "ALTER TABLE #{table} DROP CONSTRAINT #{table}_pkey;"
    execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
  end
end
