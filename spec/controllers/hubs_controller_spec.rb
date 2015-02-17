require 'rails_helper'
# require 'spec_helper'

describe HubsController do

	if ENV["GOOGLE_API_KEY"] == nil 
		$API_KEY_DEFINED = false
		pp "GOOGLE_API_KEY not defined. So testing involving the google api service will be skipped"
	else 
		$API_KEY_DEFINED = true 
	end

	before :each do
    	request.env["HTTP_ACCEPT"] = 'application/json'
  	end

	describe "GET index" do 

		context "with existing hub" do
			let(:hub) { create(:hub) }

			context "using group name of hub as filter" do
				before do 
					get :index, hub_filter: hub.group_name
				end

				it "should find hub" do
					expect(assigns(:hubs).first).to eq(hub)
				end
			end

			context "using location of hub as filter" do 
				before do 
					get :index, hub_filter: hub.formatted_location
				end

				it "should find hub" do
					expect(assigns(:hubs).first).to eq(hub)
				end

				it "should find location from google places api" do
					if $API_KEY_DEFINED
						found_hub = assigns(:hubs).second
						expect(found_hub.group_name).to eq("City of")
						expect(found_hub.formatted_location).to include(hub.formatted_location)
					end
				end

			end
		end

		context "with no existing hubs" do

			context "using non-existent group name as filter" do
				before do 
					get :index, hub_filter: "Non existent group"
				end

				it "should not find hub" do
					expect(assigns(:hubs).count).to eq 0
				end
			end

			context "using location as filter" do 
				let(:search_string) { "Mountain View" }

				before do 
					get :index, hub_filter: search_string
				end

				it "should find location from google places api" do
					if $API_KEY_DEFINED
						found_hub = assigns(:hubs).first
						expect(found_hub.group_name).to eq("City of")
						expect(found_hub.formatted_location).to include(search_string)
					end
				end

			end
		end
	end
end
