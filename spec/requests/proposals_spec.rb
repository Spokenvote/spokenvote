require 'spec_helper'

describe "Proposals" do
  describe "access proposals" do
    it "allows access to proposals with a signed in user" do
      get proposals_path
      response.status.should be(200)
    end
  end
end
