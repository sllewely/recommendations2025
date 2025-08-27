class FeedItems < ActiveRecord::Migration[8.0]
  def change
    create_table :feed_items, id: :uuid do |t|
      t.timestamps
      t.uuid :feedable_id, null: false
      t.string :feedable_type, null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false, type: :uuid
    end
  end
end
