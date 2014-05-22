class VoterMailer < ActionMailer::Base
  default from: 'Spokenvote <donotreply@spokenvote.org>',
          bcc: 'termmonitor@gmail.com'

  def vote_notification(user_id, vote_array)
    @recipient = User.find(user_id)
    @votes = Vote.where(id: vote_array)
    prop_array = []
    hub_array = []
    @votes.each do |vote|
      prop_array << vote.proposal.id
      hub_array << vote.proposal.hub_id
    end
    @props = Proposal.where(id: prop_array).order('votes_count DESC')
    @hubs = Hub.where(id: hub_array)
    mail(to: "#{@recipient.name} <#{@recipient.email}>", subject: 'New votes have arrived on your topics!') if @recipient.email.present?
  end
end
