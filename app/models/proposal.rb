# == Schema Information
#
# Table name: proposals
#
#  id          :integer          not null, primary key
#  statement   :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  votes_count :integer          default(0)
#  ancestry    :string(255)
#  created_by  :integer          # Not being used, should be deleted. We are using user_id instead.
#  hub_id      :integer
#

class Proposal < ActiveRecord::Base
  attr_accessible :statement, :supporting_statement, :user_id, :user, :supporting_votes, :hub_id, :hub,
                  :vote, :vote_attributes, :votes, :votes_attributes, :parent

  # Associations
  belongs_to :user
  belongs_to :hub
  has_many :votes, inverse_of: :proposal

  accepts_nested_attributes_for :votes, reject_if: :all_blank

  # Validations
  validates :user, :statement, presence: true

  # Scopes
  scope :roots, where(:ancestry, nil)

  # Delegations
  delegate :username, :to => :user

  # Other
  has_ancestry

  def votes_in_tree
    Rails.cache.fetch("/proposal/#{self.root.id}/votes_in_tree/#{updated_at}", :expires_at => 5.minutes) do
      [self.root, self.root.descendants].flatten.map(&:votes_count).sum
    end
  end

  def related_proposals(related_sort_by = 'votes_count DESC')
    all_proposals_in_tree = [self.root, self.root.descendants].flatten
    all_proposals_in_tree.delete(self.clone)

    if related_sort_by == 'created_at DESC'
      all_proposals_in_tree.sort! { |p1, p2| p2.created_at <=> p1.created_at }
    else
      all_proposals_in_tree.sort! { |p1, p2| p1.votes_count <=> p2.votes_count }
    end
  end
  
  def supporting_statement
    votes.where(user_id: self.user_id).first.comment
  end
  
  def supporting_votes
    votes.where("user_id != ?", self.user_id).order("created_at DESC")
  end
  
  def editable?(current_user)
    current_user && votes_count < 2 && user_id == current_user.id
  end

  def find_related_vote_in_tree_for_user(a_proposal_in_tree, user)
    proposals = a_proposal_in_tree.related_proposals
    related_votes = proposals.map(&:votes).flatten
    related_votes.each do |vote|
      return vote if vote.user == user
    end
    nil
  end

  def move_vote_to_self(user, vote_attributes)
    if vote = find_related_vote_in_tree_for_user(self, user)
      vote.ip_address = vote_attributes[:ip_address]
      vote.comment = vote_attributes[:comment]
      vote.proposal = self
      vote.save
    else
      user.votes.create({ proposal: self }.merge(vote_attributes))
    end
  end
end
