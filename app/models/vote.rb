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
#  ip_address  :string(255)
#

class Vote < ActiveRecord::Base
  # define_model_callbacks :validation, :only => :before
  attr_accessible :comment, :user, :proposal, :user_id, :proposal_id, :ip_address

  # Associations
  belongs_to :proposal, counter_cache: true, inverse_of: :votes
  belongs_to :user

  # Validations
  validates :comment, :user, :proposal, presence: true
  validates :user_id, uniqueness: { scope: [:user_id, :proposal_id], message: "You can only vote once on a proposal" }

  # Delegations
  delegate :username, :to => :user

  def self.find_related_vote_in_tree_for_user(a_proposal_in_tree, user)
    proposals = a_proposal_in_tree.related_proposals
    related_votes = proposals.map(&:votes).flatten
    related_votes.each do |vote|
      return vote if vote.user == user
    end
    nil
  end

  def self.move_user_vote_to_proposal(proposal, user, vote_attributes)
    if vote = find_related_vote_in_tree_for_user(proposal, user)
      vote.ip_address = vote_attributes[:ip_address]
      vote.comment = vote_attributes[:comment]
      vote.proposal = proposal
      vote.save
    else
      user.votes.create({ proposal: proposal }.merge(vote_attributes))
    end
  end
end
