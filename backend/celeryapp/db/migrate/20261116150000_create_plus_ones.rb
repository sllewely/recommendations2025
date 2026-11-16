class CreatePlusOnes < ActiveRecord::Migration[8.1]
  def change
    # someone coming along with a user; just a name
    create_table :plus_ones, id: :uuid do |t|
      t.timestamps
      t.string :name, null: false
      t.belongs_to :event, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.belongs_to :user, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
    end
  end
end
