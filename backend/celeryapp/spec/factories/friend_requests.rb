FactoryBot.define do
  factory :friend_request do
    association :user
    association :incoming_friend
  end
end
