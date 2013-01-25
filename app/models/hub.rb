# == Schema Information
#
# Table name: hubs
#
#  id                 :integer          not null, primary key
#  group_name         :string(255)
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  google_location_id :string(255)
#  formatted_location :string(255)
#

class Hub < ActiveRecord::Base
  attr_accessible :description, :google_location_id, :group_name, :formatted_location

  # Associations
  has_many :votes, through: :proposals
  has_many :proposals

  validates :group_name, :google_location_id, :formatted_location, presence: true

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
end
