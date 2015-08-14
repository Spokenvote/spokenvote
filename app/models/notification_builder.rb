class NotificationBuilder < ApplicationController

  def self.organize_daily_email
    notify_list = self.key_value_crossover(self.create_notify_list)
    notify_list = self.check_preferences(notify_list)
    if notify_list.count > 0
      if Rails.env.development? and 1 == 2# We might take this out for some testing where all the emails are needed.
        single_list = []
        single_list << notify_list.first
        single_list.each do |user_id, vote_array|
          VoterMailer.vote_notification(user_id, vote_array).deliver
        end
      else
        notify_list.each do |user_id, vote_array|
          VoterMailer.vote_notification(user_id, vote_array).deliver
        end
      end
    else
      if Rails.env.development?
        user_id = 44 # Likely need setup for dev's given test data
        vote_array = [ 74, 7, 12, 10, 11, 57, 54 ]
        VoterMailer.vote_notification(user_id, vote_array).deliver
        p 'Sending test votes array.'
      else
        p 'There are no new votes to notify users about.'
      end
    end
  end

  def self.check_preferences(notify_list)
    notify_list
  end

  def self.create_notify_list
    notify_list = []
    Vote.new_votes.each do |vote|
      notify_list << { vote.id => vote.find_users_in_tree }
    end
    notify_list
  end

  def self.key_value_crossover(array_of_hashes)
    crossover_result = {}
    array_of_hashes.each do |hash|
      hash.each do |key, value|
        value.each do |user_id|
          if crossover_result[user_id]
            crossover_result[user_id].push(key).sort
          else
            crossover_result[user_id] = [key]
          end
        end
      end
    end
    crossover_result
  end
end
