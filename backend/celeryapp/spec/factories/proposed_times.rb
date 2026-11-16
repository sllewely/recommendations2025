FactoryBot.define do
  factory :proposed_time do
    start_date_time { Faker::Time.between(from: DateTime.now, to: DateTime.now + 30.days) }
    association :event
  end

  factory :proposed_time_user do
    association :proposed_time
    association :user
  end
end
