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
  attr_accessible :description, :location, :name
  has_and_belongs_to_many :positions
  
  class << self
    def by_name
      order(:name)
    end
    
    def by_position_count
      Hub.joins(:positions).select("hubs.id, hubs.name, hubs.location, count(positions.id) as positions_count").order("positions_count DESC").group('hubs.id')
    end
  end
end
