FactoryBot.define do
  factory :circle do
    association :user
    name { Faker::Lorem.unique.word }

    after(:build) do |circle|
      circle.members << build(:user) if circle.members.empty?
    end
  end
end