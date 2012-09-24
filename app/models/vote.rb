class Vote < ActiveRecord::Base
  attr_accessible :comment, :user_id

  # Associations
  belongs_to :position, :counter_cache => true
  belongs_to :user
end
