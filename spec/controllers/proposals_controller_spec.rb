require 'spec_helper'

describe ProposalsController do

  describe 'POST create' do
    let(:valid_attributes) do
      {
          :statement => Faker::Lorem.sentence,
          :hub => attributes_for(:hub),
          :votes_attributes => {"0" => attributes_for(:vote)}
      }
    end

    let(:invalid_attributes) do
      {
          :hub => attributes_for(:hub),
          :votes_attributes => {"0" => attributes_for(:vote)}
      }
    end

    login_user

    before :each do
      request.env["HTTP_REFERER"] = '/'
    end

    describe 'with valid parameters' do
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
end