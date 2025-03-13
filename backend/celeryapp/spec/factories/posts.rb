FactoryBot.define do
  factory :post do
    post_title { Faker::Hipster.sentence }
    content { Faker::Hipster.paragraph }
    association :user
  end
end
