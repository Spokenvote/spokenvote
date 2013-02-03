require 'spec_helper'

describe ProposalsController do

  describe 'POST create' do
    login_user

    pending 'creates a new proposal' do
      expect {
        post :create, :proposal => {:statement =>'my first proposal'}
      }.to change(Proposal, :count).by(1)
    end
  end

end
