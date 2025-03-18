FactoryBot.define do
  factory :recommendation do
    title { Faker::Book.title }

    media_type { 'book' }
    status { 'interested' }
    association :user

  end
end
