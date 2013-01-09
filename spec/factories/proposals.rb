FactoryGirl.define do
  factory :proposal do
    user
    statement { Faker::Lorem.sentence }
  end
end
