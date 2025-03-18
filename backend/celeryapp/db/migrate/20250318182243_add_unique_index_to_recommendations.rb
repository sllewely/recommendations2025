class AddUniqueIndexToRecommendations < ActiveRecord::Migration[8.0]
  def change
    add_index :recommendations, [:user_id, :title, :media_type], unique: true

  end
end
