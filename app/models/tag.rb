class Tag < ActiveRecord::Base
  attr_accessible :label, :slug
  
  belongs_to :position
  has_and_belongs_to_many :positions
end
