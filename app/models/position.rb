class Position < ActiveRecord::Base
  attr_accessible :parent_id, :statement, :user_id
  
  belongs_to :user
  belongs_to :parent, :class_name => 'position', :foreign_key => 'parent_id'
  
  has_and_belongs_to_many :governing_body
  has_and_belongs_to_many :tags
end
