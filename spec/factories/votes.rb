FactoryGirl.define do
  factory :vote do
    proposal FactoryGirl.build(:proposal)
    comment  'Comment on my vote'
    user FactoryGirl.build(:user) 
  end
end
