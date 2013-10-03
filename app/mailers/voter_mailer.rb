class VoterMailer < ActionMailer::Base
  default from: 'donotreply@spokenvote.org'

  def new_votes_on_topic(user)
    mail(:to => user.email, :subject => 'New Spokenvotes Have Been Cast')
  end

  def new_proposal_on_topic(proposal)
    proposal.all_related_proposals.each do |related_proposal|
      related_proposal.votes.each do |voter|
        @voter_email = voter.email
        mail(to: 'termmonitor@gmail.com', subject: 'A New Spokenvote Proposal Has Been Made')
      end
    end
  end
end
