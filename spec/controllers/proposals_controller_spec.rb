require 'spec_helper'

describe ProposalsController do
  login_user

  before :each do
    request.env["HTTP_REFERER"] = '/'
  end

  describe 'POST create new proposal with existing hub' do
    let(:hub) { create(:hub) }

    describe 'with valid parameters' do
      let(:valid_attributes) do
        {
          :statement => Faker::Lorem.sentence,
          :hub => hub.attributes,
          :votes_attributes => {"0" => attributes_for(:vote)}
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

      it 'sets the success flash message' do
        post :create, :proposal => valid_attributes
        should set_the_flash.to 'Successfully created the proposal.'
      end
    end

    describe 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          :hub => hub.attributes,
          :votes_attributes => {"0" => attributes_for(:vote)}
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

      it 'sets the failure flash message' do
        post :create, :proposal => invalid_attributes
        should set_the_flash.to 'Failed to create the proposal'
      end
    end
  end

  describe 'POST create improve an existing proposal' do
    describe 'with valid parameters' do
      let(:hub) { create(:hub) }

      let(:user1) { create(:user) }
      let!(:proposal1) { create(:proposal, user: user1, hub: hub, statement: 'Proposal-1') }
      let!(:vote1) { create(:vote, user: user1, proposal: proposal1, comment: 'Proposal-1 --> Vote-1') }

      let(:current_user) { user } # Logged in user
      let(:valid_attributes) { attributes_for(:proposal, parent_id: proposal1.id, votes_attributes: attributes_for(:vote)) }

      it 'creates a new improved proposal' do
        expect {
          post :create, :proposal => valid_attributes
        }.to change(Proposal, :count).by(1)
      end
    end
  end
end