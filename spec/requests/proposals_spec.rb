require 'spec_helper'

describe "Positions" do
  describe "GET /proposals" do
    it "test access to proposals, works without a signed in user" do
      get proposals_path
      response.status.should be(200)
    end
  end
end
