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
  has_many :proposals  # replaces # has_many :proposals, through: :votes

  # Named Scopes
  scope :by_group_name, lambda { |group_name| where("LOWER(group_name) = ?", group_name.downcase) }
  
  validates :group_name, presence: true

  class << self
    def by_group
      order(:group)
    end

    def by_proposal_count
      Hub.joins(:proposals).select("hubs.id, hubs.group_name, count(proposals.id) as proposals_count").order("proposals_count DESC").group('hubs.id')
    end
  end
end
