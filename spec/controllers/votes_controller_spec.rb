require 'spec_helper'

describe VotesController do
  login_user

  before :each do
    request.env["HTTP_REFERER"] = '/'
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  let(:hub) { create(:hub) }
  # let!(:user1) { user }
  let(:current_user) { user } # Logged in user
  let!(:user2) { create(:user) }
  let!(:proposal1) { create(:proposal, user: user2, hub: hub) }
  let!(:vote1) { create(:vote, proposal: proposal1, user: user2) }

  describe 'POST creates' do

    context 'current user has no other vote in the proposal tree' do
      it 'creates a new vote' do
        expect {
          post :create, vote: { proposal_id: proposal1.id, comment: "Coz it rocks!"}
        }.to change(Vote, :count).by(1)
        expect(assigns(:vote).user).to eq(current_user)
        expect(assigns(:vote).proposal).to eq(proposal1)
        expect(Proposal.find_by_id(proposal1.id).votes_count).to eq(2)
      end
    end

    context 'current user has vote already on this proposal' do
      let!(:proposal2) { create(:proposal, user: current_user, parent: proposal1, hub: hub) }
      let!(:vote2) { create(:vote, proposal: proposal2, user: current_user) }

      it 'should not create a new vote' do
        expect {
          post :create, vote: { proposal_id: proposal2.id, comment: "Coz this modified proposal rocks better!"}
        }.to change(Vote, :count).by(0)
        expect(Proposal.find_by_id(proposal1.id).votes_count).to eq(1)
        expect(Proposal.find_by_id(proposal2.id).votes_count).to eq(1)
      end

      it 'moves the vote from the proposal2 to proposal1' do
        expect {
          post :create, vote: { proposal_id: proposal1.id, comment: "Changed my mind, the original one rocks better!"}
        }.to change(Vote, :count).by(0)
        expect(assigns(:vote).user).to eq(current_user)
        expect(assigns(:vote).proposal_id).to eq(proposal1.id)
        expect(Proposal.find_by_id(proposal1.id).votes_count).to eq(2)
        expect(Proposal.find_by_id(proposal2.id).votes_count).to eq(0)
      end
    end
  end
end