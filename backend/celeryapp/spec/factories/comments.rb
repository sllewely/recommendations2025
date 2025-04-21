FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    association :user

    for_post

    trait :for_post do
      association :commentable, factory: :post
    end

    trait :for_event do
      association :commentable, factory: :event
    end

    trait :for_recommendation do
      association :commentable, factory: :recommendation
    end

  end
end
