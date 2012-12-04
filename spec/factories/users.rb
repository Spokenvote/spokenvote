FactoryGirl.define do
  factory :user do
    name { Faker.name }
    email { Faker::Internet.email }
    password "secret"
    password_confirmation "secret"
  end
end
