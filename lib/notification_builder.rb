class NotificationBuilder
  class << self
    def organize_daily_email
      notify_list = key_value_crossover(create_notify_list)
      notify_list = check_preferences(notify_list)
      if notify_list.count > 0
        # We might take this out for some testing where all the emails are needed.
        notify_list = notify_list.take(1) if Rails.env.development? and false

        notify_list.each do |user_id, vote_array|
          VoterMailer.vote_notification(user_id, vote_array).deliver
        end
      else
        if Rails.env.development?
          VoterMailer.vote_notification(Rails.configuration.test_user_id, Raisl.configuration.test_vote_ids).deliver
          p 'Sending test votes array.'
        else
          p 'There are no new votes to notify users about.'
        end
      end
    end

    # create_notify_list should return an array of key (vote.id) value (an array of user_ids) pairs
    # However, the mailer will want the inverse pairing, a key of a user.id and the vote.ids that she needs to be informed about.
    # So one must crack open each hash and convert it across
    # This is done in the key_value_crossover

    def check_preferences(notify_list)
      # Stubbed this out for now
      create_notify_list
    end

    def create_notify_list
      Vote.new_votes.map do |vote|
        { vote.id => vote.find_users_in_tree }
      end
    end

    def key_value_crossover(array_of_hashes)
      crossover_result = {}
      array_of_hashes.each do |hash|
        hash.each do |key, value|
          value.each do |user_id|
            crossover_result[user_id] ||= []
            crossover_result[user_id].push(key).sort
          end
        end
      end
      crossover_result
    end
  end
end
# Tested in irb with the seed data set...

# So I give you a vote, called current_vote.
# From current_vote, find the relevant proposal.
# From that proposal, call #all_related_proposals
# For each of those proposals, collect all votes
# iterate over all the votes, including only the ones older than current_vote, and
# grabbing the user_ids for each of them.
# So you now have the current_vote and all the user_ids that need to be notified of that current_vote.
# The method should return a hash, with the current_vote.id as the key and the value being an array of all the user_id that need to know about it