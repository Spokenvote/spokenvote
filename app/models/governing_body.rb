class GoverningBody < ActiveRecord::Base
  attr_accessible :description, :location, :name
  has_and_belongs_to_many :positions
end
