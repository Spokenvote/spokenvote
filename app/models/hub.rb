# == Schema Information
#
# Table name: hubs
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  location    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Hub < ActiveRecord::Base
  attr_accessible :description, :location, :group

  # Associations
  belongs_to :location
  has_many :votes
  has_many :proposals, :through => :votes
  
  class << self
    def by_group
      order(:group)
    end
    
    def by_proposal_count
      Hub.joins(:proposals).select("hubs.id, hubs.group, count(proposals.id) as proposals_count").order("proposals_count DESC").group('hubs.id')
    end
  end
end
