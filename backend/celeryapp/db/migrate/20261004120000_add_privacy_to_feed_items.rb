class AddPrivacyToFeedItems < ActiveRecord::Migration[8.1]
  def up
    # 0 = public, 1 = friends, 2 = specific
    add_column :feed_items, :visibility, :integer, null: false, default: 0
    add_index :feed_items, :created_at
    add_index :feed_items, [:user_id, :created_at]

    # remove duplicate feed items / circle memberships before adding unique indexes
    execute <<~SQL
      DELETE FROM feed_items a USING feed_items b
      WHERE a.feedable_type = b.feedable_type AND a.feedable_id = b.feedable_id
        AND (a.created_at, a.id) > (b.created_at, b.id)
    SQL
    execute <<~SQL
      DELETE FROM user_circles a USING user_circles b
      WHERE a.member_id = b.member_id AND a.circle_id = b.circle_id
        AND (a.created_at, a.id) > (b.created_at, b.id)
    SQL

    add_index :feed_items, [:feedable_type, :feedable_id], unique: true
    add_index :user_circles, [:member_id, :circle_id], unique: true

    create_table :feed_item_audiences, id: :uuid do |t|
      t.references :feed_item, type: :uuid, null: false, index: false, foreign_key: { on_delete: :cascade }
      t.references :user, type: :uuid, index: false, foreign_key: { on_delete: :cascade }
      t.references :circle, type: :uuid, index: false, foreign_key: { on_delete: :cascade }
      t.timestamps
      t.check_constraint "num_nonnulls(user_id, circle_id) = 1", name: "feed_item_audiences_one_grantee"
      t.index :feed_item_id
      t.index [:user_id, :feed_item_id], unique: true, where: "user_id IS NOT NULL"
      t.index [:circle_id, :feed_item_id], unique: true, where: "circle_id IS NOT NULL"
    end
  end

  def down
    drop_table :feed_item_audiences
    remove_index :user_circles, [:member_id, :circle_id]
    remove_index :feed_items, [:feedable_type, :feedable_id]
    remove_index :feed_items, [:user_id, :created_at]
    remove_index :feed_items, :created_at
    remove_column :feed_items, :visibility
  end
end
