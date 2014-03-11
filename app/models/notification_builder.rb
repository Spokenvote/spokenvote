class NotificationBuilder

  def self.organize_daily_email
    notify_list = self.key_value_crossover(self.create_notify_list)

  end
  # create_notify_list should an array of key (vote.id) value (an array of user_ids) pairs]
  # However, the mailer will want the inverse pairing, a key of a user.id and the vote.ids that she needs to be informed about.
  # So one must crack open each hash and convert it across

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

  def reverse_hash

  end
end

# [
#   {3 => [1,3,5]},
#   {4 => [4,3,9]},
#   {5 => [2,3,5]}
# ]


# { 1: [3],
#   3: [3, 4, 5],
#   5: [3, 5],
#   4: [4],
#   9: [4],
#   2: [5]
# }



# Tested in irb with the seed data set...

# So I give you a vote, called current_vote.
# From current_vote, find the relevant proposal.
# From that proposal, call #all_related_proposals
# For each of those proposals, collect all votes
# iterate over all the votes, including only the ones older than current_vote, and
# grabbing the user_ids for each of them.
# So you now have the current_vote and all the user_ids that need to be notified of that current_vote.
# The method should return a hash, with the current_vote.id as the key and the value being an array of all the user_id that need to know about it
#