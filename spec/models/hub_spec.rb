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

require 'rails_helper'

describe Hub do
  before(:each) do
    @attr = {
      :group_name => Faker.name,
      :description => Faker::Lorem.paragraph
    }
  end

  it "should require a group name" do
    no_group_hub = Hub.new(@attr.merge(:group_name => ""))
    expect(no_group_hub).to be_invalid
  end

end
