require 'spec_helper'

describe ProposalsController do
  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe 'POST create' do
    login_user

    context 'with existing hub' do
      let(:hub) { create(:hub) }

      describe 'new proposal' do
        describe 'with valid parameters' do
          let(:valid_attributes) do
            {
              statement: Faker::Lorem.sentence,
              hub_id: hub.id,
              votes_attributes: [{ comment: 'That is why i support it' }]
            }
          end

          it 'creates a new proposal' do
            expect {
              post :create, :proposal => valid_attributes
            }.to change(Proposal, :count).by(1)
          end

          it "increases the vote count by 1" do
            expect {
              post :create, :proposal => valid_attributes
            }.to change(Vote, :count).by(1)
          end

          it "creates a valid vote" do
            post :create, :proposal => valid_attributes

            vote = Vote.find_by_user_id_and_proposal_id(user.id, assigns(:proposal).id)
            vote.should_not be_nil
          end

          it "updates the votes_count attribute of the proposal loaded in memory" do
            post :create, :proposal => valid_attributes
            assigns(:proposal).votes_count.should == 1
          end
        end

        describe 'with invalid parameters' do
          let(:invalid_attributes) do
            {
              :hub => hub.attributes,
              :votes_attributes => { "0" => attributes_for(:vote) }
            }
          end

          it 'should not create a new proposal' do
            expect {
              post :create, :proposal => invalid_attributes
            }.to change(Proposal, :count).by(0)
          end

          it 'should not increase the vote count' do
            expect {
              post :create, :proposal => invalid_attributes
            }.to change(Vote, :count).by(0)
          end
        end
      end

      describe 'improve proposal' do
        describe 'with valid parameters' do
          let(:hub) { create(:hub) }
          let(:current_user) { user } # Logged in user

          context 'user has no other vote in the proposal tree' do
            let(:user1) { create(:user) }
            let!(:proposal1) { create(:proposal, user: user1, hub: hub, statement: 'Proposal-1') }
            let!(:vote1) { create(:vote, user: user1, proposal: proposal1, comment: 'Proposal-1 --> Vote-1') }
            let(:valid_attributes) { attributes_for(:proposal, parent_id: proposal1.id, votes_attributes: attributes_for(:vote)) }

            it 'creates a new improved proposal' do
              expect {
                post :create, :proposal => valid_attributes
              }.to change(Proposal, :count).by(1)
            end

            it 'should increase the votes count by 1' do
              expect {
                post :create, :proposal => valid_attributes
              }.to change(Vote, :count).by(1)
            end

            it "updates the votes_count attribute of the proposal loaded in memory" do
              post :create, :proposal => valid_attributes
              assigns(:proposal).votes_count.should == 1
            end
          end

          context 'user has an existing vote in the proposal tree' do
            let(:user1) { create(:user) }

            let!(:proposal1) { create(:proposal, user: current_user, hub: hub, statement: 'Proposal-1') }
            let!(:vote1) { create(:vote, user: current_user, proposal: proposal1, comment: 'Proposal-1 --> Vote-1') }

            let!(:proposal2) { create(:proposal, user: user1, hub: hub, statement: 'Proposal-1 --> Proposal-2', parent: proposal1) }
            let!(:vote2) { create(:vote, user: user1, proposal: proposal2, comment: 'Proposal-1 --> Proposal-2 --> Vote-1') }

            let(:valid_attributes) { attributes_for(:proposal, parent_id: proposal2.id, votes_attributes: attributes_for(:vote)) }

            it 'creates a new improved proposal' do
              expect {
                post :create, :proposal => valid_attributes
              }.to change(Proposal, :count).by(1)
            end

            it 'should not increase the votes count' do
              expect {
                post :create, :proposal => valid_attributes
              }.to change(Vote, :count).by(0)
            end
          end
        end
      end
    end

    context 'without existing hub' do
      describe 'create new proposal while creating a new hub' do
        describe 'with valid parameters' do
          let(:valid_attributes) do
            {
              statement: Faker::Lorem.sentence,
              hub_attributes: {
                group_name: 'Hacker Dojo',
                location_id: 'somerandomgoogleplacesid',
                formatted_location: 'Mountain View, CA'
              },
              votes_attributes: [{ comment: 'That is why i support it' }]
            }
          end

          it 'creates a new proposal' do
            expect {
              post :create, :proposal => valid_attributes
            }.to change(Proposal, :count).by(1)
          end

          it "increases the vote count by 1" do
            expect {
              post :create, :proposal => valid_attributes
            }.to change(Vote, :count).by(1)
          end

          it "creates a valid vote" do
            post :create, :proposal => valid_attributes

            vote = Vote.find_by_user_id_and_proposal_id(user.id, assigns(:proposal).id)
            vote.should_not be_nil
          end

          it "updates the votes_count attribute of the proposal loaded in memory" do
            post :create, :proposal => valid_attributes
            assigns(:proposal).votes_count.should == 1
          end

          it 'creates a new hub' do
            expect {
              post :create, :proposal => valid_attributes
            }.to change(Hub, :count).by(1)
          end
        end
      end
    end
  end

  describe 'Get index' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    let!(:user4) { create(:user) }
    let!(:hub1) { create(:hub, group_name: 'State of California') }
    let!(:hub2) { create(:hub, group_name: 'The United Nations') }
    let!(:proposal1) { create(:proposal, statement: 'Taxes should be reduced by 5% in California', hub: hub1, user: user1) }
    let!(:proposal2) { create(:proposal, statement: 'Public transportation should be improved in California', hub: hub1, user: user1) }
    let!(:proposal3) { create(:proposal, statement: 'Animals should not be killed for food', hub: hub2, user: user1) }
    let!(:vote1) { create(:vote, proposal: proposal1, user: user1) }
    let!(:vote2) { create(:vote, proposal: proposal1, user: user2) }
    let!(:vote3) { create(:vote, proposal: proposal1, user: user3) }
    let!(:vote4) { create(:vote, proposal: proposal2, user: user2) }
    let!(:vote5) { create(:vote, proposal: proposal3, user: user1) }
    let!(:vote6) { create(:vote, proposal: proposal3, user: user2) }

    describe 'New' do
      it 'returns all new proposals' do
        get :index, { filter: 'new' }
        assigns(:proposals).should match_array([proposal1, proposal2, proposal3])
      end

      it 'returns new proposals for a particular hub' do
        get :index, { filter: 'new', hub: hub1.id }
        assigns(:proposals).should match_array([proposal1, proposal2])
      end

      it 'returns the list of proposals in reverse order of the their updates' do
        get :index, { filter: 'new' }
        assigns(:proposals).should == [proposal3, proposal2, proposal1]
      end
    end

    describe 'Active' do
      it 'returns all active proposals' do
        get :index, { filter: 'active' }
        assigns(:proposals).should match_array([proposal1, proposal2, proposal3])
      end

      it 'returns active proposals for a particular hub' do
        get :index, { filter: 'active', hub: hub2.id }
        assigns(:proposals).should match_array([proposal3])
      end

      it 'returns the list of proposals in reverse order of the number of votes received in the whole proposal tree' do
        forked_proposal2 = create(:proposal, statement: 'Public transportation should be made better California', hub: hub1, user: user4, parent: proposal2)
        forked_proposal3 = create(:proposal, statement: 'Animals should not be killed for seafood', hub: hub2, user: user4, parent: proposal3)
        vote7 = create(:vote, proposal: forked_proposal2, user: user1)
        vote8 = create(:vote, proposal: forked_proposal2, user: user2)
        vote9 = create(:vote, proposal: forked_proposal2, user: user3)

        get :index, { filter: 'active' }
        assigns(:proposals).should == [proposal2, proposal1, proposal3]
      end
    end

    describe 'My Votes' do
      before :each do
        login_with_user(user1)
      end

      it 'returns all proposals on which the current user voted' do
        get :index, { filter: 'my_votes' }
        assigns(:proposals).should match_array([proposal1, proposal3])
      end

      it 'returns all proposals for a particular hub on which the current user voted' do
        get :index, { filter: 'my_votes', hub: hub1.id }
        assigns(:proposals).should match_array([proposal1])
      end
    end
  end
end