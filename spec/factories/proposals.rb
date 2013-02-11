FactoryGirl.define do
  factory :proposal do
    statement { Faker::Lorem.sentence }
  end
end
