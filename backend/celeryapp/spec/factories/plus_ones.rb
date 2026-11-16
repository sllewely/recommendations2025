FactoryBot.define do
  factory :plus_one do
    name { Faker::Name.first_name }
    association :event
    association :user
  end
end
