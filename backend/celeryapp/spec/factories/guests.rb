FactoryBot.define do
  factory :guest do
    name { Faker::Name.first_name }
  end

  factory :guest_rsvp do
    status { :going }
    association :guest
    association :event
  end

  factory :proposed_time_guest do
    association :proposed_time
    association :guest
  end
end
