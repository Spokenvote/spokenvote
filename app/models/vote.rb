# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  proposal_id :integer
#  comment     :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :integer
#

class Vote < ActiveRecord::Base
  attr_accessible :comment, :user, :proposal, :user_id, :proposal_id, :hub_id, :hub, :ip_address, :location

  # Associations
  belongs_to :proposal, :counter_cache => true
  belongs_to :user
  belongs_to :hub
  belongs_to :location

  validates :comment, :user_id, :proposal_id, :location_id, :presence => true
  validates :user_id, :uniqueness => {:scope => [:user_id, :proposal_id], :message => "Can't vote on the same issue twice."}
end
