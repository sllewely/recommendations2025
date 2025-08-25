FactoryBot.define do
  factory :post do
    post_title { Faker::Hipster.sentence }
    content { Faker::Hipster.paragraph }
    association :user

    after(:create) do |post|
      create(:feed_item, feedable: post, user: post.user)
    end
  end

end
