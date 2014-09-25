require 'spec_helper'

describe GooglePlacesAutocompleteService do

	if ENV["GOOGLE_API_KEY"] == nil 
		$API_KEY_DEFINED = false
		pp "GOOGLE_API_KEY not defined. So testing involving the google api service will be skipped"
	else 
		$API_KEY_DEFINED = true 
	end

	describe '#find_regions' do 
		before do 
			if $API_KEY_DEFINED
				@service = GooglePlacesAutocompleteService.new 
			end
		end

		context "city search" do 
			if $API_KEY_DEFINED
				it "locates and identifies the city" do 
					locations = @service.find_regions("Mountain View")
					expect(locations[0][:description]).to eq("Mountain View, CA, United States")
					expect(locations[0][:id]).to eq("bb51f066ff3fd0b033db94b4e6172da84b8ae111")
					expect(locations[0][:type]).to eq("City of")
					expect(locations[0][:reference]).to_not be_nil
				end
			end
		end 

		context "county search" do 
			if $API_KEY_DEFINED
				it "locates and identifies the county" do 
					locations = @service.find_regions("Santa Clara County")
					expect(locations[0][:description]).to eq("Santa Clara County, CA, United States")
					expect(locations[0][:id]).to eq("1019a381cf34eb999ba02adcfeaf3f066d662fb1")
					expect(locations[0][:type]).to eq("County of")
					expect(locations[0][:reference]).to_not be_nil
				end
			end
		end 

		context "state search" do 
			if $API_KEY_DEFINED
				it "locates and identifies the state" do 
					locations = @service.find_regions("California")
					expect(locations[0][:description]).to eq("California, United States")
					expect(locations[0][:id]).to eq("b993df4055071925c7950dc2afd22c0b98f994e0")
					expect(locations[0][:type]).to eq("State of")
					expect(locations[0][:reference]).to_not be_nil
				end
			end
		end

		context "country search" do 
			if $API_KEY_DEFINED
				it "locates and identifies the country" do 
					locations = @service.find_regions("United States")
					expect(locations[0][:description]).to eq("United States")
					expect(locations[0][:id]).to eq("88564d30369b045e767b90442f46a1245864c58f")
					expect(locations[0][:type]).to eq("Country of")
					expect(locations[0][:reference]).to_not be_nil
				end
			end
		end 

		# context "old district search" do
		# 	if $API_KEY_DEFINED
		# 		it "locates and does not return entry" do
		# 			locations = @service.find_regions("Hampton Beach")
		# 			expect(locations[0][:description]).to eq("Hampton Beach, Hampton, NH, United States")
		# 			expect(locations[0][:id]).to eq("5f59aebc53bba8ff82b7dc98ea629977e58ebaf8")
		# 			expect(locations[0][:type]).to eq("District of")
		# 			expect(locations[0][:reference]).to_not be_nil
		# 		end
		# 	end
		# end

    context "new district search" do
			if $API_KEY_DEFINED
				it "locates and does not return entry" do
					locations = @service.find_regions("Hampton Beach")
					expect(locations[0][:description]).to eq("Hampton Beach, Hampton, NH, United States")
					expect(locations[0][:id]).to eq("5f59aebc53bba8ff82b7dc98ea629977e58ebaf8")
					expect(locations[0][:type]).to eq("District of")
					expect(locations[0][:reference]).to_not be_nil
				end
			end
		end

  end

	describe '#get_place_details' do 
		before do 
			if $API_KEY_DEFINED
				@service = GooglePlacesAutocompleteService.new 
				locations = @service.find_regions("Mountain View")
				@reference = locations[0][:reference] 
			end
		end

		context "city search" do 
			if $API_KEY_DEFINED
				it "get details for the location identified by the reference" do 
					location = @service.get_place_details(@reference)
					expect(location[:description]).to include("Mountain View")
					expect(location[:id]).to eq("bb51f066ff3fd0b033db94b4e6172da84b8ae111")
					expect(location[:type]).to eq("City of")
					expect(location[:reference]).to eq(@reference)
				end
			end
		end 
	end
end
