FactoryBot.define do
  factory :user do
    # TODO: make unique
    name { Faker::Name.name }
    username { Faker::Internet.unique.username }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 12) }
  end
end