class AddUrlRecommendation < ActiveRecord::Migration[8.0]
  def change
    add_column :recommendations, :url, :string
  end
end
