FactoryBot.define do
  factory :event do
    title { Faker::Music.band }
    description { Faker::Hipster.sentence }
    start_date_time { Faker::Time.between(from: DateTime.now, to: DateTime.now + 30.days) }
    address { Faker::Address.full_address }
    url { Faker::Internet.url }
    event_type { 'concert' }
    is_public { false }
    association :user

    after(:create) do |event|
      create(:feed_item, feedable: event, user: event.user)
    end
  end
end
