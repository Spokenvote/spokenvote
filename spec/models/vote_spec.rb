# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  proposal_id :integer
#  comment     :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ip_address  :string(255)
#

require 'spec_helper'

describe Vote do
  let(:vote) { build(:vote) }

  describe 'validations' do
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

    it "should save empty-string comments as null" do
      vote = FactoryGirl.create(vote)
      vote.comment = ''
      vote.save!

      expect(vote.comment).to eq nil
    end
  end

  describe '#new_votes' do
    let!(:user)  { create(:user) }
    let!(:hub)   { create(:hub) }
    let!(:proposal1) { create(:proposal, hub: hub, user: user) }
    let!(:proposal2) { create(:proposal, hub: hub, user: user) }
    let!(:proposal3) { create(:proposal, hub: hub, user: user) }
    let!(:vote1) { create(:vote, :comment => "Once more into the breach", :user => user, :proposal => proposal1) }
    let!(:vote2) { create(:vote, :comment => "Once more into the breach", :user => user, :proposal => proposal2) }
    let!(:vote3) { create(:vote, :comment => "Once more into the breach", :updated_at => 48.hours.ago, :user => user, :proposal => proposal3) }

    it "should return all votes created in the last 24 hours" do
      expect(Vote.new_votes).to match_array([vote1, vote2])
    end
  end

  subject { vote }
  it { expect(:find_users_in_tree).to respond_to }
end
