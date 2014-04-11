class VoterMailer < ActionMailer::Base
  default from: 'Spokenvote <donotreply@spokenvote.org>'

  def vote_notification(user_id, vote_array)
    @recipient = User.find(user_id)
    @votes = vote_array.map { |vote_id| Vote.find(vote_id) }
    # attachments["bluefull.png"] = File.read("#{Rails.root}/app/assets/images/bluefull.png")
    mail(to: "#{@recipient.name} <#{@recipient.email}>", subject: 'New votes have arrived on your topics!')
  end
end
