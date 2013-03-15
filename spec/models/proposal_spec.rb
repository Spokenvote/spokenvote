require 'spec_helper'

describe Proposal do
  before(:each) do
    @user_attr = {
      :name => Faker.name,
      :email => Faker::Internet.email,
      :password => "secret",
      :password_confirmation => "secret",
    }
    @hub_attr = {
      :group_name => Faker.name,
      :description => Faker::Lorem.paragraph
    }
    @attr = {
      :statement => Faker::Lorem.sentence,
      :user => User.new(@user_attr),
      :hub => Hub.new(@hub_attr)
    }
  end

  it "should require a statement" do
    no_statement_proposal = Proposal.new(@attr.merge(:statement => ""))
    no_statement_proposal.should_not be_valid
  end

  it "should require a user" do
    no_user_proposal = Proposal.new(@attr.merge(:user => nil))
    no_user_proposal.should_not be_valid
  end

  it "should require a hub" do
    no_hub_proposal = Proposal.new(@attr.merge(:hub => nil))
    no_hub_proposal.should_not be_valid
  end
end
