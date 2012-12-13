# == Schema Information
#
# Table name: positions
#
#  id          :integer          not null, primary key
#  statement   :string(255)
#  user_id     :integer
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  votes_count :integer          default(0)
#  ancestry    :string(255)
#

class Position < ActiveRecord::Base
  attr_accessible :parent_id, :parent, :statement, :user_id, :user, :votes, :votes_attributes

  # Associations
  belongs_to :user
  belongs_to :parent, :class_name => 'position', :foreign_key => 'parent_id'
  has_many :votes
  has_and_belongs_to_many :hubs
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :votes, :reject_if => :all_blank

  # Validations
  validates :user_id, :presence => true
  validates :statement, :presence => true

  # Other
  has_ancestry
  
  class << self
    def by_hub
      Hub.by_name.map {|gb| gb.positions if gb.positions }.reject {|gb| gb == []}.flatten
    end
  end

  def votes_in_tree
    Rails.cache.fetch("/position/#{self.root.id}/votes_in_tree/#{updated_at}", :expires_at => 5.minutes) do
      [self.root, self.root.descendants].flatten.map(&:votes_count).sum
    end
  end

  def related_positions
    all_positions_in_tree = [self.root, self.root.descendants].flatten
    all_positions_in_tree.delete(self.clone)
    all_positions_in_tree
  end
end
