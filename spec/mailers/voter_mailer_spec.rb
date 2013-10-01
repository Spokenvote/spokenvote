require "spec_helper"

describe VoterMailer do
  #let(:creator) { create(:user) }
  let(:user) { create(:user) }
  #let(:project) { create(:project) }
  let(:new_vote) { create(:vote, user: user) }

  describe 'new_vote email' do
    let(:mail) { VoterMailer.new_votes_on_topic(user) }
    subject { mail }
    it { should deliver_to user.email }
    it { should deliver_from 'donotreply@spokenvote.org' }
    #it { should have_subject "[Spokenvote] (#{project.name}) New task" }
    it { should have_body_text "A new task has been created." }
    end
end
