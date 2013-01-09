FactoryGirl.define do
  factory :vote do
    proposal
    hub
    user
    comment { Faker::Lorem.sentence }
  end
end
