FactoryBot.define do
  factory :user_status do
    association :user
    status { Faker::Twitter.status }
  end
end
