class CreateUserStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :user_statuses do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false
    end
  end
end
