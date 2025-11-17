class CreateUsersCircles < ActiveRecord::Migration[8.1]
  def change
    create_table :users_circles, id: :uuid do |t|
      t.timestamps
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.references :circle, type: :uuid, foreign_key: true, null: false
    end
  end
end
