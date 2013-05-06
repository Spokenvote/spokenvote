require 'spec_helper'

describe VotesController do
  login_user

  before :each do
    request.env["HTTP_REFERER"] = '/'
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  let(:hub) { create(:hub) }
  let!(:user1) { user }
  let!(:user2) { create(:user) }
  let!(:proposal1) { create(:proposal, user: user2, hub: hub) }
  let!(:vote1) { create(:vote, proposal: proposal1, user: user2) }

  describe 'POST creates' do
    context 'current user has no other vote in the proposal tree' do
      it 'creates a new vote' do
        expect {
          post :create, vote: { proposal_id: proposal1.id, comment: "Coz it rocks!"}
        }.to change(Vote, :count).by(1)
      end
    end

    context 'current user has one vote in the proposal tree' do
      let!(:proposal2) { create(:proposal, user: user1, parent: proposal1, hub: hub) }
      let!(:vote2) { create(:vote, proposal: proposal2, user: user1) }

      it 'does not create a new vote' do
        expect {
          post :create, vote: { proposal_id: proposal1.id, comment: "Coz this modified proposal rocks better!"}
        }.to change(Vote, :count).by(0)
      end

      it 'moves the vote from the previous proposal to the new one' do
        post :create, vote: { proposal_id: proposal1.id, comment: "Changed my mind, the original one rocks better!"}
        assigns(:vote).user.should == user1
        assigns(:vote).proposal.should == proposal1
      end
    end
  end
end