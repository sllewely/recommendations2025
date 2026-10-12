FactoryBot.define do
  factory :feed_item_audience do
    association :feed_item
    association :user
  end
end
