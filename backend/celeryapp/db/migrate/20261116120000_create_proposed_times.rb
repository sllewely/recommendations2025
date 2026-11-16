class CreateProposedTimes < ActiveRecord::Migration[8.1]
  def change
    # candidate start times an event creator offers while finding a time
    create_table :proposed_times, id: :uuid do |t|
      t.timestamps
      t.datetime :start_date_time, null: false
      t.belongs_to :event, null: false, foreign_key: true, type: :uuid
    end
    add_index :proposed_times, [:event_id, :start_date_time], unique: true

    # a user's vote for a proposed time
    create_table :proposed_times_users, id: :uuid do |t|
      t.timestamps
      t.belongs_to :proposed_time, null: false, foreign_key: true, type: :uuid
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
    end
    add_index :proposed_times_users, [:proposed_time_id, :user_id], unique: true
  end
end
