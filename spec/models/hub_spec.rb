# == Schema Information
#
# Table name: hub
#
#    t.string   "group_name"
#    t.text     "description"
#    t.datetime "created_at",         :null => false
#    t.datetime "updated_at",         :null => false
#    t.string   "location_id"
#    t.string   "formatted_location"
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
