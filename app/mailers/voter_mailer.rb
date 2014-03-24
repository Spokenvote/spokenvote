class VoterMailer < ActionMailer::Base
  default from: "donotreply@spokenvote.org"

  def vote_notification(user_notifications)
    recipient_id = user_notifications.keys[0]
    @recipient = User.find(recipient_id)
    @votes = user_notifications[recipient_id].map { |vote_id| Vote.find(vote_id) }
    attachments["bluefull.png"] = File.read("#{Rails.root}/app/assets/images/bluefull.png")
    mail(:to => "#{@recipient.name} <#{@recipient.email}>", :subject => "[Spokenvote] People have voted on topics you are interested in!")
  end
end
