# == Schema Information
#
# Table name: hubs
#
#  id                 :integer          not null, primary key
#  group_name         :string(255)
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  location_id        :string(255)
#  formatted_location :string(255)
#

class Hub < ActiveRecord::Base
  attr_accessible :description, :location_id, :group_name, :formatted_location, :full_hub, :short_hub

  # Associations
  has_many :votes, through: :proposals
  has_many :proposals

  validates :group_name, :location_id, :formatted_location, presence: true
  validates :group_name, uniqueness: {scope: :formatted_location}

  class << self
    def by_group
      order(:group)
    end
    
    # No named scopes, they're going away ;)
    def by_group_name(target_group)
      where("LOWER(group_name) = ?", target_group.downcase)
    end

    def by_location(target_location)
      where("LOWER(formatted_location) = ?", target_location.downcase)
    end

    def by_proposal_count
      Hub.joins(:proposals).select("hubs.id, hubs.group_name, count(proposals.id) as proposals_count").order("proposals_count DESC").group('hubs.id')
    end
  end

  def full_hub
    self.group_name + ' - ' + self.formatted_location
  end
  
  def short_hub
    if self.group_name == 'All of'
      split = self.formatted_location.split(',')
      if split.count > 2
        ret = split[0] + ', ' +split[2]
      else
        ret = self.formatted_location
      end
      ret = self.group_name + ' - ' + ret
    else
      ret = self.group_name
    end
    return ret
  end
end
