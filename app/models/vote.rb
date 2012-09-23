class Vote < ActiveRecord::Base
  attr_accessible :comment
  
  belongs_to :position
  belongs_to :user
end
