FactoryGirl.define do
  new_proposal = FactoryGirl.build(:proposal)
  new_user     = FactoryGirl.build(:user)
  new_proposal.save
  new_user.save
  factory :vote do
    proposal_id new_proposal.id 
    comment  'The comment'
    user_id new_user.id 
  end
end
