require 'spec_helper'

describe Vote do
  let(:vote) { build(:vote) }

  describe 'validations' do
    it { should validate_presence_of(:comment) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:proposal) }

    describe 'uniqueness' do
      before(:each) do
        user = create(:user)
        proposal = create(:proposal, hub: create(:hub), user: user)
        create(:vote, comment: 'Blah', proposal: proposal, user: user)
      end

      it { should validate_uniqueness_of(:user_id).scoped_to(:proposal_id).with_message('You can only vote once on a proposal') }
    end
  end
end
