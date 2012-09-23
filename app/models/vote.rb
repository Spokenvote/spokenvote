class Vote < ActiveRecord::Base
  attr_accessible :comment, :position_id, :user_id
  
  belongs_to :position
  belongs_to :user
end
