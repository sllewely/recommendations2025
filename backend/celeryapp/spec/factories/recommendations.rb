FactoryBot.define do
  factory :recommendation do
    title { Faker::Book.title }

    media_type { 'book' }
    association :user

  end
end
