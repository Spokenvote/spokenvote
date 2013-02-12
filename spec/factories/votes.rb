FactoryGirl.define do
  factory :vote do
    comment { Faker::Lorem.sentence }
  end
end
