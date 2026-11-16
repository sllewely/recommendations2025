class CreateGuests < ActiveRecord::Migration[8.1]
  def change
    # someone without an account, remembered by a token in their browser
    create_table :guests, id: :uuid do |t|
      t.timestamps
      t.string :name, null: false
      t.string :email
      t.string :token, null: false
    end
    add_index :guests, :token, unique: true

    create_table :guest_rsvps, id: :uuid do |t|
      t.timestamps
      t.integer :status, default: 0, null: false
      t.belongs_to :guest, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.belongs_to :event, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
    end
    add_index :guest_rsvps, [:guest_id, :event_id], unique: true

    # a guest's vote for a proposed time
    create_table :proposed_times_guests, id: :uuid do |t|
      t.timestamps
      t.belongs_to :proposed_time, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.belongs_to :guest, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
    end
    add_index :proposed_times_guests, [:proposed_time_id, :guest_id], unique: true
  end
end
