class CreatePostRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :post_recommendations do |t|
      t.integer :post_id
      t.integer :recommendation_id
      
      t.timestamps
    end
  end
end
