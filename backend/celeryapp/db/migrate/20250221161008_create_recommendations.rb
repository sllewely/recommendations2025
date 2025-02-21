class CreateRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :recommendations do |t|
      t.timestamps
      t.string :name, null: false
      t.text :description
      t.string :who_recommended
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end
