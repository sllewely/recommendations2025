FactoryBot.define do
  factory :group do
    name { Faker::Lorem.unique.word }
  end
end