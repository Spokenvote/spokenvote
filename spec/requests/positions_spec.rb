require 'spec_helper'

describe "Positions" do
  describe "GET /positions" do
    it "test access to positions, works without a signed in user" do
      get positions_path
      response.status.should be(200)
    end
  end
end
