class AddReactions < ActiveRecord::Migration[8.1]
  def change
    create_table :reactions, id: :uuid do |t|
      t.timestamps
      t.string :react, null: false
      t.belongs_to :reactable, polymorphic: true, type: :uuid
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
    end
  end
end
