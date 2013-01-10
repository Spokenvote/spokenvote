# == Schema Information
#
# Table name: hubs
#
#  id          :integer          not null, primary key
#  group_name  :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :integer
#

class Hub < ActiveRecord::Base
  attr_accessible :description, :location, :group_name

  # Associations
  belongs_to :location
  has_many :votes
  has_many :proposals, :through => :votes

  scope :by_group_name, lambda { |group_name| where("LOWER(group_name) = ?", group_name.downcase) }

  class << self
    def by_group
      order(:group)
    end

    def by_proposal_count
      Hub.joins(:proposals).select("hubs.id, hubs.group_name, count(proposals.id) as proposals_count").order("proposals_count DESC").group('hubs.id')
    end
  end
end
