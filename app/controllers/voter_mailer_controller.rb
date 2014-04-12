class VoterMailerController < ApplicationController

  def vote_notification
    if organize_test_email
      user_id = @user_id
      p user_id
      @recipient = User.find(user_id)
      @votes = @vote_array.map { |vote_id| Vote.find(vote_id) }
      # render voter_mailer: 'vote_notification'
      render layout: false
    end
  end

  def organize_test_email
    notify_list = NotificationBuilder.key_value_crossover(NotificationBuilder.create_notify_list)
    notify_list = NotificationBuilder.check_preferences(notify_list)
    if notify_list.count > 0
      if Rails.env.development? # We might take this out for some testing where all the emails are needed.
        single_list = []
        single_list << notify_list.first
        single_list.each do |user_id, vote_array|
          @user_id = user_id
          @vote_array = vote_array
          # VoterMailer.vote_notification(user_id, vote_array).deliver
        end
      else
        notify_list.each do |user_id, vote_array|
          VoterMailer.vote_notification(user_id, vote_array).deliver
        end
      end
    else
      p 'There are no new votes to notify users about today.'
    end
  end

end