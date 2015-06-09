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
#  created_by  :integer
#  hub_id      :integer
#

class Proposal < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :hub
  has_many :votes, inverse_of: :proposal

  accepts_nested_attributes_for :votes, reject_if: :all_blank
  accepts_nested_attributes_for :hub, reject_if: :all_blank

  # Validations
  validates :user, :statement, :hub, presence: true

  # Delegations
  delegate :username, to: :user

  # Scopes
  scope :by_recency, -> { order(updated_at: :desc) }
  scope :by_hub, ->(hub) { hub ? where(hub_id: hub.id) : all }
  scope :by_user, ->(user) { user ? where(user_id: user.id) : all }
  scope :by_voting_user, ->(user) { user ? joins(:votes).where(votes: {user_id: user.id}) : all }

  # Other
  has_ancestry

  def votes_in_tree
    # Rails.cache.fetch("/proposal/#{self.root.id}/votes_in_tree/#{updated_at}", :expires_at => 5.minutes) do
    # Code above seemed to never expire as of Rails 4
    # Proper cache should only cache when votes_in_tree > 100 or so
    all_related_proposals.map(&:votes_count).sum
    # end
  end

  def related_proposals(related_sort_by = 'Most Votes')
    other_supported_proposals = self.all_related_proposals.select(&:has_support?) - [self]

    case related_sort_by
    when "Most Votes"
      other_supported_proposals.sort! { |p1, p2| p2.votes_count <=> p1.votes_count }
    when "Least Votes"
      other_supported_proposals.sort! { |p1, p2| p1.votes_count <=> p2.votes_count }
    when "Most Recently Voted on"
      other_supported_proposals.sort! { |p1, p2| p2.recent_vote <=> p1.recent_vote }
    when "Oldest Most Recent Vote"
      other_supported_proposals.sort! { |p1, p2| p1.recent_vote <=> p2.recent_vote }
    else
      other_supported_proposals.sort! { |p1, p2| p1.votes_count <=> p2.votes_count }
    end
  end

  def self.top_voted_proposal_in_tree
    Proposal.roots.map{|root| root.all_related_proposals.max_by(&:votes_count) }.compact.uniq
  end

  def all_related_proposals
    self.root.subtree
  end

  def supporting_statement
    self.user.votes.first.comment
  end

  #TODO should be named "additional_supporting_votes?"
  def supporting_votes
    votes.where.not(user_id: self.user_id).by_recency
  end

  def has_support?
    self.votes_count > 0
  end

  def votes_percentage
    (100.0 * (self.votes.size.to_f / self.votes_in_tree)).round
    # sprintf('%d%%', (100.0 * (self.votes.size.to_f / self.votes_in_tree)).round)
  end

  def editable?(current_user)
    current_user && votes_count < 2 && current_user == self.user
  end

  def current_user_support?(current_user)
    current_user && self.votes.find_by(user_id: current_user.id).present?
  end

  def recent_vote
    return self.created_at if self.votes.blank?
    self.votes.by_recency.first.created_at
  end
end
