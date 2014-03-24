class NotificationBuilder

  def self.organize_daily_email
    notify_list = self.key_value_crossover(self.create_notify_list)
    notify_list = self.check_preferences(notify_list)
    notify_list.each do |user_notifications|
      VoterMailer.vote_notification(user_notifications)
    end
  end
  # create_notify_list should an array of key (vote.id) value (an array of user_ids) pairs]
  # However, the mailer will want the inverse pairing, a key of a user.id and the vote.ids that she needs to be informed about.
  # So one must crack open each hash and convert it across

  def self.check_preferences(notify_list)
    # Stubbed this out for now
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

  def self.mail(user_notifications)
    recipient = User.find(user_notifications.keys[0])
    votes = Vote.find(user_notifications.values)

    require 'mandrill'
    m = Mandrill::API.new
    rendered_html = m.templates.render 'notification', [{:name => 'main', :content => 'The main content block'}]
    # rendered_text = m.templates.render 'notification', [{:name => 'main', :content => 'The main content block'}]
    message = {
     :subject=> "Update from SpokenVote",
     :from_name=> "SpokenVote",
     :text=>"Hi message, how are you?",
     :to=>[
       {
         :email=> "#{recipient.email}",
         :name=> "#{recipient.name}"
       }
     ],
     :html=>"<html><h1>People have been a <strong>voting</strong></h1></html>",
     :from_email=>"info@spokenvote.org"
    }
    sending = m.messages.send message
  end

  def self.mail_test
    require 'mandrill'
    m = Mandrill::API.new
    message = {
     :subject=> "Update from SpokenVote",
     :from_name=> "SpokenVote",
     :text=>"Hi message, how are you?",
     :to=>[
       {
         :email=> "thomasgabriel.watson@gmail.com",
         :name=> "Tom"
       }
     ],
     :html=>"<html><h1>Hi <strong>message</strong>, how are you?</h1></html>",
     :from_email=>"info@spokenvote.org"
    }
    sending = m.messages.send message
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
#