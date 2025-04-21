class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.timestamps
      t.bigint :commentable_id, null: false
      t.string :commentable_type, null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.text :body, null: false
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
