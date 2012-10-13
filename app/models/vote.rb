class Vote < ActiveRecord::Base
  attr_accessible :comment, :user_id, :position_id

  # Associations
  belongs_to :position, :counter_cache => true
  belongs_to :user
  
  validates :comment, :user_id, :position_id, :presence => true
end
