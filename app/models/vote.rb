# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  position_id :integer
#  comment     :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Vote < ActiveRecord::Base
  attr_accessible :comment, :user, :position, :user_id, :position_id

  # Associations
  belongs_to :position, :counter_cache => true
  belongs_to :user
  
  validates :comment, :user_id, :position_id, :presence => true
end
