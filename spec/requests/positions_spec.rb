require 'spec_helper'

describe "Positions" do
  describe "GET /positions" do
    it "test access to positions, works with a signed in user" do
      sign_in_as_a_valid_user
      get positions_path
      response.status.should be(200)
    end
  end

  describe "GET /positions" do
    it "test access to positions, does not work without a signed in user" do
      get positions_path
      response.status.should be(302) # redirect to sign in page
    end
  end
end
