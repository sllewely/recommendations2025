FactoryBot.define do
  factory :reaction do
    react { 'like' }
    association :user

    for_post

    trait :for_post do
      association :reactable, factory: :post
    end

    trait :for_event do
      association :reactable, factory: :event
    end

    trait :for_recommendation do
      association :reactable, factory: :recommendation
    end

  end
end
