FactoryBot.define do
  factory :recommendation do
    title { Faker::Book.unique.title }

    media_type { 'book' }
    status { 'interested' }
    association :user

    after(:create) do |recommendation|
      create(:feed_item, feedable: recommendation, user: recommendation.user)
    end
  end
end
