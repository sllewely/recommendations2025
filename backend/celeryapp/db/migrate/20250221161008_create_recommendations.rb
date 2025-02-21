class CreateRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :recommendations do |t|
      t.timestamps
      t.string :name, null: false
      t.text :description
      t.string :who_recommended
    end
  end
end
