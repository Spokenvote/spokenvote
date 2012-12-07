require 'spec_helper'

describe "Votes" do
  describe "GET /votes" do
    it "test access to votes, works with a signed in user" do
      sign_in_as_a_valid_user
      get votes_path
      response.status.should be(200)
    end
  end

  describe "GET /votes" do
    it "test access to votes, does not work without a signed in user" do
      get votes_path
      response.status.should be(302) # redirect to sign in page
    end
  end
end
