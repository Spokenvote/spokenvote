FactoryGirl.define do
  factory :vote do
    proposal
    user
    comment { Faker::Lorem.sentence }
  end
end
