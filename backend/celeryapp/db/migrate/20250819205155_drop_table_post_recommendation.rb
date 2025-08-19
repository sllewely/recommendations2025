class DropTablePostRecommendation < ActiveRecord::Migration[8.0]
  def change
    drop_table :post_recommendations
  end
end
