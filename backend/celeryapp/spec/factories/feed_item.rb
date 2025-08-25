FactoryBot.define do
  factory :feed_item do
    association :user
    association :feedable, factory: :post
  end
end
