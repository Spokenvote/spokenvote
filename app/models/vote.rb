class Vote < ActiveRecord::Base
  attr_accessible :comment, :user_id
  
  belongs_to :position
  belongs_to :user
end
