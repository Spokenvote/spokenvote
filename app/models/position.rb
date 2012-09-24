class Position < ActiveRecord::Base
  attr_accessible :parent_id, :statement, :user_id, :governing_id, :votes, :votes_attributes
  
  # Associations
  belongs_to :user
  belongs_to :parent, :class_name => 'position', :foreign_key => 'parent_id'
  has_many :votes
  has_and_belongs_to_many :governing_body
  has_and_belongs_to_many :tags
  
  accepts_nested_attributes_for :votes, :reject_if => :all_blank
end
