# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name "MyString"
    type 1
    parent_id 1
    ancestry "MyString"
  end
end
