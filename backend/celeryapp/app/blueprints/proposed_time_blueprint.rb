class ProposedTimeBlueprint < Blueprinter::Base
  identifier :id
  fields :start_date_time

  field :vote_count do |proposed_time|
    proposed_time.users.size
  end

  view :unauthed do
  end

  view :authed do
    association :users, blueprint: UserBlueprint, view: :unauthed
  end
end
