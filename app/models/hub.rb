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
  #attr_accessible :description, :location_id, :group_name, :formatted_location, :full_hub, :short_hub
  # TODO  Code comments can be deleted.
  # Associations
  has_many :votes, through: :proposals
  has_many :proposals

  validates :group_name, :location_id, :formatted_location, presence: true
  validates :group_name, uniqueness: {scope: :formatted_location}

  def full_hub
    self.group_name + ' - ' + self.formatted_location
  end

  def short_hub
    if GooglePlacesAutocompleteService.location_types.include?(self.group_name)
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

  def select_id 
    if self.id == 0
      "#{GooglePlacesAutocompleteService.prefix}#{self.description}"
    else
      self.id
    end
  end

end
