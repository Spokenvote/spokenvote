require 'spec_helper'

describe Proposal do
  let(:proposal) { FactoryGirl.build(:proposal)}
  let(:proposal_with_improvement) { FactoryGirl.build(:proposal_with_improvment) }

  # it "counts the votes in a simple tree" do
  #   proposal.votes_in_tree.should == 1
  # end

  # it "counts the votes if the proposal has an improvement" do
  #   proposal_with_improvement.votes_in_tree.should == 2
  # end

  # it "has the correct related proposals" do
  #   proposal.save
  #   proposal.related_proposals.size.should == 2
  # end
end
