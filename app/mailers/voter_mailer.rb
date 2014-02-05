class VoterMailer < ActionMailer::Base
  default from: 'donotreply@spokenvote.org'

  def new_votes_on_topic(proposal)
    proposal.all_related_proposals.each do |related_proposal|
      related_proposal.votes.each do |voter|
        @voter = voter
        attachments["bluefull.png"] = File.read("#{Rails.root}/app/assets/images/bluefull.png")
        mail(:to => "#{voter.username} <#{voter.email}>", :subject => 'New Spokenvotes Have Been Cast') do |format|
          format.html { render "voter_mailer/new_votes_on_topic" }
        end.deliver
      end
    end
  end

  def new_proposal_on_topic(proposal)
    proposal.all_related_proposals.each do |related_proposal|
      related_proposal.votes.each do |voter|
        @voter = voter
        attachments["bluefull.png"] = File.read("#{Rails.root}/app/assets/images/bluefull.png")
        mail(to: "#{voter.username} <#{voter.email}>", subject: 'A New Spokenvote Proposal Has Been Made')
      end
    end
  end

end
