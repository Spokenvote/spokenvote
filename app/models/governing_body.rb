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
  end
end
