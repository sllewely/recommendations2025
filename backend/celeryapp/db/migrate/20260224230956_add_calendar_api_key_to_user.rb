class AddCalendarApiKeyToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :calendar_api_key, :uuid, default: "gen_random_uuid()", null: false
    add_index :users, :calendar_api_key, unique: true
  end
end