FactoryGirl.define do
  factory :vote do
    proposal build(:proposal)
    comment  'Comment on my vote'
    user build(:user)
  end
end
