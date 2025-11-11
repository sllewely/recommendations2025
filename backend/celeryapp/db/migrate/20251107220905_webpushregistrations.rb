class Webpushregistrations < ActiveRecord::Migration[8.0]
  def change
    create_table :web_push_registrations, id: :uuid do |t|
      t.string :endpoint, null: false
      t.string :auth, null: false
      t.string :p256dh, null: false
      t.references :user, null: false, type: :uuid, foreign_key: true
      t.datetime :expires_at
      t.timestamps
    end
  end
end
