require 'spec_helper'

describe "Votes" do
  describe "access votes" do
    # *** Waiting for Voting functionality to return, what which time all of the below can be uncommented ***

    # it "allows access with a signed in user" do
    #   sign_in_as_a_valid_user
    #   get votes_path
    #   response.status.should be(200)
    # end

    it "denies access without a signed in user" do
      get votes_path
      response.status.should be(302)
    end
  end

  # Can't add support for headless browser testing on Travis CI until Poltergeist gem support Capybara 2.0
  describe "create votes", :type => :feature, :unless => ENV["TRAVIS"] do
    let(:proposal) { FactoryGirl.create(:vote).proposal }

    it "creates a new vote for a proposal", :js => true do
      sign_in_as_a_valid_user
      visit proposal_path(proposal)

      click_link "Support"
      fill_in "vote_comment", with: Faker::Lorem.sentence
      expect { click_link "Vote for this proposal" }.to change(Vote, :count).by(1)

      page.should have_content("Vote was successfully created")
    end
  end
end
