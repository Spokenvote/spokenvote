class VoterMailerController < ApplicationController

  def vote_notification
    if organize_test_email
      @recipient = User.find(@user_id)
      @votes = @vote_array.map { |vote_id| Vote.find(vote_id) }
      if Rails.env.development?
        render layout: false
      else
        render status: :forbidden
      end
    end
  end

  def organize_test_email
    notify_list = NotificationBuilder.key_value_crossover(NotificationBuilder.create_notify_list)
    if notify_list.count > 0
        single_list = []
        single_list << notify_list.first
        single_list.each do |user_id, vote_array|
          @user_id = user_id
          @vote_array = vote_array
        end
    else
      @user_id = 44
      @vote_array = [95]
    end
  end
end