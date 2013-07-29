# == Schema Information
#
# Table name: proposals
#
#  id          :integer          not null, primary key
#  statement   :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  votes_count :integer          default(0)
#  ancestry    :string(255)
#  created_by  :integer
#  hub_id      :integer
#

require 'spec_helper'

describe Proposal do
  before(:each) do
    @user_attr = {
      :name => Faker.name,
      :email => Faker::Internet.email,
      :password => "secret",
      :password_confirmation => "secret",
    }
    @hub_attr = {
      :group_name => Faker.name,
      :description => Faker::Lorem.paragraph
    }
    @attr = {
      :statement => Faker::Lorem.sentence,
      :user => User.new(@user_attr),
      :hub => Hub.new(@hub_attr)
    }
  end

  it "should require a statement" do
    no_statement_proposal = Proposal.new(@attr.merge(:statement => ""))
    no_statement_proposal.should_not be_valid
  end

  it "should require a user" do
    no_user_proposal = Proposal.new(@attr.merge(:user => nil))
    no_user_proposal.should_not be_valid
  end

  it "should require a hub" do
    no_hub_proposal = Proposal.new(@attr.merge(:hub => nil))
    no_hub_proposal.should_not be_valid
  end

  describe 'scopes' do
    let!(:user) { create(:user) }
    let!(:hub) { create(:hub) }

    let!(:root_proposal1) { create(:proposal, user_id: user.id, hub_id: hub.id, votes_count: 5) }
    let!(:proposal2) { create(:proposal, user_id: user.id, hub_id: hub.id, parent_id: root_proposal1.id, votes_count: 10) }
    let!(:proposal3) { create(:proposal, user_id: user.id, hub_id: hub.id, parent_id: proposal2.id, votes_count: 3) }

    let!(:root_proposal4) { create(:proposal, user_id: user.id, hub_id: hub.id, votes_count: 1) }
    let!(:proposal5) { create(:proposal, user_id: user.id, hub_id: hub.id, parent_id: root_proposal4.id, votes_count: 2) }
    let!(:proposal6) { create(:proposal, user_id: user.id, hub_id: hub.id, parent_id: root_proposal4.id, votes_count: 5) }

    describe '#top_voted_proposal_in_tree' do
      it 'returns a list of all the top voted proposals' do
        Proposal.top_voted_proposal_in_tree.should match_array([proposal2, proposal6])
      end
    end
  end

  describe '#related_proposals' do
    it 'excludes self' do
      proposal1 = stub_model(Proposal, id: 1)
      forked_proposal1 = stub_model(Proposal, id: 2)

      proposal1.should_receive(:all_related_proposals).and_return([proposal1, forked_proposal1])
      proposal1.related_proposals.should_not include(proposal1)
    end

    it 'does not included proposals without any votes' do
      proposal1 = stub_model(Proposal, id: 1, votes_count: 3)
      forked_proposal1 = stub_model(Proposal, id: 2, votes_count: 0)
      forked_proposal2 = stub_model(Proposal, id: 3, votes_count: 2)

      proposal1.should_receive(:all_related_proposals).and_return([proposal1, forked_proposal1, forked_proposal2])
      proposal1.related_proposals.should match_array([forked_proposal2])
    end
  end
end
