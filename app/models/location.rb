# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  type_id    :integer
#  parent_id  :integer
#  ancestry   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Location < ActiveRecord::Base
  attr_accessible :ancestry, :name, :parent_id, :type_id

  TYPES = {
    country: 1,
    state: 2,
    city: 3,
    county: 4,
    postal: 5
  }
end
