class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups, id: :uuid do |t|
      t.timestamps
      t.string :name, null: false
    end
  end
end
