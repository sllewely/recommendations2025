FactoryBot.define do
  factory :circle do
    association :user
    name { Faker::Lorem.unique.word }

  end
end