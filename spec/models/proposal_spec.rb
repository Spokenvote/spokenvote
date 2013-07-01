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
end
