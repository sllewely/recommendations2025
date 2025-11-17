class CreateCircles < ActiveRecord::Migration[8.1]
  def change
    create_table :circles, id: :uuid do |t|
      t.timestamps
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.string :name, null: false
    end
  end
end
