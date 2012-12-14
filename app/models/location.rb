class Location < ActiveRecord::Base
  attr_accessible :ancestry, :name, :parent_id, :type

  TYPES = {
    country: 1,
    state: 2,
    city: 3,
    county: 4,
    postal: 5
  }
end
