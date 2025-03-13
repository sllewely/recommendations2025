class CreateRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :recommendations do |t|
      t.timestamps
      t.string :title, null: false
      t.text :notes
      t.string :media_type
      t.string :who_recommended
      t.integer :status, default: 0 # completed/interested/etc
      t.integer :rating, default: 0 # unrated enum
      t.belongs_to :user, index: true, foreign_key: true, null: false
    end
  end
end
