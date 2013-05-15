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
  validates :user, :statement, :hub, presence: true

  # Delegations
  delegate :username, :to => :user

  # Scopes
  scope :noop, -> { where("1 = 1") }
  scope :by_hub, lambda { |hub_id| hub_id ? where(hub_id: hub_id) : noop }

  # Other
  has_ancestry

  def votes_in_tree
    Rails.cache.fetch("/proposal/#{self.root.id}/votes_in_tree/#{updated_at}", :expires_at => 5.minutes) do
      [self.root, self.root.descendants].flatten.map(&:votes_count).sum
    end
  end

  def related_proposals(related_sort_by = 'Most Votes')
    all_proposals_in_tree = [self.root, self.root.descendants].flatten
    all_proposals_in_tree.delete(self.clone)

    case related_sort_by
    when "Most Votes"
      all_proposals_in_tree.sort! { |p1, p2| p1.votes_count <=> p2.votes_count }
    when "Least Votes"
      all_proposals_in_tree.sort! { |p1, p2| p2.votes_count <=> p1.votes_count }
    when "Most Recently Voted on"
      all_proposals_in_tree.sort! { |p1, p2| p1.votes.order('created_at DESC').first.created_at <=> p2.votes.order('created_at DESC').first.created_at}
    when "Oldest Most Recent Vote"
      all_proposals_in_tree.sort! { |p1, p2| p2.votes.order('created_at DESC').first.created_at <=> p1.votes.order('created_at DESC').first.created_at}
    else
      all_proposals_in_tree.sort! { |p1, p2| p1.votes_count <=> p2.votes_count }
    end
  end
  
  def supporting_statement
    votes.where(user_id: self.user_id).first.comment
  end
  
  #TODO should be named "additional_supporting_votes?"
  def supporting_votes
    votes.where("user_id != ?", self.user_id).order("created_at DESC")
  end
  
  def editable?(current_user)
    current_user && votes_count < 2 && user_id == current_user.id
  end

  def has_support?
    self.votes.any?
  end

  def votes_percentage
    sprintf('%d%%', (100.0 * (self.votes.size.to_f / self.votes_in_tree)).round)
  end
end
