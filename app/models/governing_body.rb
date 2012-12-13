# == Schema Information
#
# Table name: governing_bodies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  location    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class GoverningBody < ActiveRecord::Base
  attr_accessible :description, :location, :name
  has_and_belongs_to_many :positions
  
  class << self
    def by_name
      order(:name)
    end
    
    def by_position_count
      GoverningBody.joins(:positions).select("governing_bodies.id, governing_bodies.name, governing_bodies.location, count(positions.id) as positions_count").order("positions_count DESC").group('governing_bodies.id')
    end
  end
end
