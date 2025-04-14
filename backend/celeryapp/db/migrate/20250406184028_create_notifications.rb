class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.timestamps
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.string :message, null: false
      t.boolean :active, default: true
      t.json :extras, default: {}
      t.integer :notif_type, null: false
    end
  end
end
