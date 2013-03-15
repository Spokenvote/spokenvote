require 'spec_helper'

describe Vote do
 let(:vote) { FactoryGirl.build(:vote) }

 it "creates a new vote given valid attributes" do
   vote.should be_valid
   vote.save.should be_true
 end

 it "requires a vote to have a proposal" do
   vote.proposal = nil
   vote.should_not be_valid
   vote.should have(1).error_on(:proposal)
 end

 it "requires a vote to have a user" do
   vote.user = nil
   vote.should_not be_valid
   vote.should have(1).error_on(:user)
 end

 it "requires a vote to have a comment" do
   vote.comment = nil
   vote.should_not be_valid
   vote.should have(1).error_on(:comment)
 end

 it "does not allow a user to vote for the same proposal twice" do
   vote.save
   p vote
   p vote.proposal
   p vote.user
   second_vote = FactoryGirl.build(:vote, proposal_id: vote.proposal.id, user_id: vote.user.id)
   p second_vote
   second_vote.should_not be_valid
   second_vote.errors_on(:user_id).should include("Can't vote on the same issue twice.")
 end
end
