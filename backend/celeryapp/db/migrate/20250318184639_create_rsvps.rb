class CreateRsvps < ActiveRecord::Migration[8.0]
  def change
    create_table :rsvps do |t|
      t.timestamps
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.belongs_to :event, null: false, index: true, foreign_key: true
      t.integer :status, default: 0
    end

    add_index :rsvps, [:user_id, :event_id], unique: true
  end
end
