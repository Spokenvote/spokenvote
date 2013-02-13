FactoryGirl.define do
  factory :vote do
    proposal FactoryGirl.build(:proposal)
    comment  'The comment'
    user     FactoryGirl.build(:user)
  end
end
