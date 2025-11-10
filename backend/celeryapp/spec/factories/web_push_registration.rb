FactoryBot.define do
  factory :web_push_registration do
    association :user
    endpoint { Faker::Internet.url }
    p256dh { Faker::Crypto.sha256 }
    auth { Faker::Crypto.sha256 }
  end
end