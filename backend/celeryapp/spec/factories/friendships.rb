FactoryBot.define do
  factory :friendship do
    association :user
    association :friend
  end
end
