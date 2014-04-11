class VoterMailerController < ApplicationController

  def vote_notification
    render voter_mailer: 'vote_notification'
  end

  def help
  end
end