class AddChosenProposedTimeToEvents < ActiveRecord::Migration[8.1]
  def change
    # the proposed time the host picked as the winner
    add_reference :events, :chosen_proposed_time, type: :uuid, null: true,
                  foreign_key: { to_table: :proposed_times, on_delete: :nullify }
  end
end
