class VoterMailer < ActionMailer::Base
  default from: 'Spokenvote <donotreply@spokenvote.org>',
          bcc: 'termmonitor@gmail.com'

  def vote_notification(user_id, vote_array)
    @recipient = User.find(user_id)
    @votes = Vote.where(id: vote_array)
    @props = Proposal.where(id: @votes.map(&:proposal_id)).order('votes_count DESC')
    @hubs = Hub.where(id: @votes.map{|v| v.proposal.hub_id})
    mail(to: "#{@recipient.name} <#{@recipient.email}>", subject: 'New votes have arrived on your topics!') if @recipient.email.present?
  end
end
