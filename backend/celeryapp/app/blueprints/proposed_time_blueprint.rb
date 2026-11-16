class ProposedTimeBlueprint < Blueprinter::Base
  identifier :id
  fields :start_date_time

  field :vote_count do |proposed_time|
    proposed_time.users.size + proposed_time.guests.size
  end

  field :guest_ids do |proposed_time|
    proposed_time.guests.map(&:id)
  end

  # anyone with the event link can see who voted
  association :users, blueprint: UserBlueprint, view: :unauthed
  association :guests, blueprint: GuestBlueprint

  view :unauthed do
  end

  view :authed do
  end
end
