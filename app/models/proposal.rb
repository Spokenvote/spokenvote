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
    # TODO Please determine if this is the right way to get sorting done
    if related_sort_by == 'created_at DESC'
      all_proposals_in_tree.sort! {|p1, p2| p2.created_at <=> p1.created_at}
    elsif related_sort_by == 'created_at DESC'
      all_proposals_in_tree.sort! {|p1, p2| p1.created_at <=> p2.created_at}
    else
      all_proposals_in_tree.sort! {|p1, p2| p1.votes_count <=> p2.votes_count}
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
end
