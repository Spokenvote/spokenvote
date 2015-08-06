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
  #attr_accessible :comment, :user, :proposal, :user_id, :proposal_id, :ip_address

  # Associations
  belongs_to :proposal, counter_cache: true, touch: true
  belongs_to :user

  # scopes
  default_scope { by_last_updated }

  scope :by_last_updated, -> { order(updated_at: :desc) }
  scope :by_recency, -> { order(created_at: :desc) }

  # Validations
  validates :user, :proposal, presence: true
  validates :user_id, uniqueness: { scope: [:user_id, :proposal_id], message: "You can only vote once on a proposal" }
  # last argument needs converting to a lamda for Rails4

  # Delegations
  delegate :username, :email, :gravatar_hash, :facebook_auth, to: :user

  before_save :normalize_empty_comments

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
      vote.update(
          ip_address: vote_attributes[:ip_address],
          comment: vote_attributes[:comment],
          proposal_id: proposal.id
      )
    else
      vote = user.votes.build({ proposal: proposal }.merge(vote_attributes))
    end
    status = vote.save
    return status, vote
  end

  def self.find_any_vote_in_tree_for_user(a_proposal_in_tree, user)
    proposals = a_proposal_in_tree.all_related_proposals
    related_votes = proposals.map(&:votes).flatten
    related_votes.each do |vote|
      return vote if vote.user == user
    end
    nil
  end

  def self.new_votes
    last_check = 10.minutes.ago
    Vote.where("updated_at >= ?", last_check)
  end

  def find_users_in_tree
    users_in_tree = []
    if self.proposal
      self.proposal.all_related_proposals.each do |proposal|
        proposal.votes.each do |vote|
          if vote.updated_at < self.updated_at
            users_in_tree << vote.user_id
          end
        end
      end
     end
    users_in_tree
  end

  def normalize_empty_comments
    self.comment = self.comment.presence
  end
end
