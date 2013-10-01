class VoterMailer < ActionMailer::Base
  default from: 'donotreply@spokenvote.org'

  def new_votes_on_topic(user)
    mail(:to => user.email, :subject => 'New Spokenvotes Have Been Cast')
  end
end
