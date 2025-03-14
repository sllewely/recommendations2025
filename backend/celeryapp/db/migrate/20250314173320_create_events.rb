class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.timestamps
      t.string :title, null: false
      t.string :description
      t.date :date, null: false
      t.integer :start_time
      t.string :address
      t.string :url
      t.string :event_type
      t.belongs_to :user, index: true, foreign_key: true, null: false
    end
  end
end
