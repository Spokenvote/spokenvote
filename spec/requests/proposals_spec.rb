require 'spec_helper'

describe "Proposals" do
  describe "access proposals" do
    it "allows access to proposals with a signed in user" do
      get proposals_path
      response.status.should be(200)
    end
  end

  describe "improve proposal", :type => :feature, :unless => ENV["TRAVIS"] do
    let(:proposal) { FactoryGirl.create(:vote).proposal }

    it "creates a new proposal", :js => true do
      sign_in_as_a_valid_user
      visit proposal_path(proposal)

      click_link "Improve"
      fill_in "proposal_statement", with: "#{Faker::Lorem.sentence} Improved"
      expect { click_link "Save this improved proposal" }.to change(Proposal, :count).by(1)

      # page.should have_content("Related proposal was successfully created")
    end
  end
end
