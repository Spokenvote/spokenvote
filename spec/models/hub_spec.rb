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

require 'spec_helper'

describe Hub do
  before(:each) do
    @attr = {
      :group_name => Faker.name,
      :description => Faker::Lorem.paragraph
    }
  end

  it "should require a group name" do
    no_group_hub = Hub.new(@attr.merge(:group_name => ""))
    no_group_hub.should_not be_valid
  end

end
