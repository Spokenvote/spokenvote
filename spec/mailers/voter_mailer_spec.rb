require "spec_helper"

describe VoterMailer do
  let!(:user1) { create(:user, name: 'Jim John', email: 'user1@user.com') }
  let!(:user2) { create(:user, name: 'Bill Bob', email: 'user2@user.com') }
  let!(:user3) { create(:user, name: 'Tim Tom', email: '') }

  let!(:hub1) { create(:hub, group_name: 'State of California') }

  let!(:proposal1) { create(:proposal, statement: 'P1: Taxes should be reduced by 5% in California', hub: hub1, user: user1) }

  let!(:vote1) { create(:vote, user: user1, proposal: proposal1) }
  let!(:vote2) { create(:vote, user: user2, proposal: proposal1) }
  let!(:vote3) { create(:vote, user: user3, proposal: proposal1) }

  let!(:user_id_1) { user1.id }
  let!(:votes_for_user_1) { [vote2.id, vote3.id] }

  describe 'new_vote email' do
    let(:mail) { VoterMailer.vote_notification(user_id_1, votes_for_user_1) }
    subject { mail }
    it 'sends an email' do
      # expect(mail.to).to eq("#{user1.username} <#{user1.email}>")
      expect(mail.to).to match_array("#{user1.email}")
      # expect(mail.from).to match_array('Spokenvote <donotreply@spokenvote.org>')
      expect(mail.from).to match_array('donotreply@spokenvote.org')
      expect(mail.body.encoded).to match('New Supporters')
    end
  end

  let!(:user_id_3) { user3.id }
  let!(:votes_for_user_3) { [vote1.id, vote2.id] }

  describe 'tries blank email address' do
    let(:mail) { VoterMailer.vote_notification(user_id_3, votes_for_user_3) }
    subject { mail }
    it 'sends an email' do
      expect(mail.to).to be_nil
      expect(mail.from).to be_nil
    end
  end
end
