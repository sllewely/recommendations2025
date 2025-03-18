FactoryBot.define do
  factory :rsvp do
    association :user
    association :event
    status { 'interested' }

  end
end
