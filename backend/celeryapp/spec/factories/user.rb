FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 12) }
  end
end