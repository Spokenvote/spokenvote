require 'spec_helper'

describe GooglePlacesAutocompleteService do

	describe '#find_regions' do 
		before do 
			@service = GooglePlacesAutocompleteService.new 
		end

		context "city search" do 
			it "locates and identifies the city" do 
				locations = @service.find_regions("Mountain View")
				expect(locations[0][:description]).to eq("Mountain View, CA, United States")
				expect(locations[0][:id]).to eq("bb51f066ff3fd0b033db94b4e6172da84b8ae111")
				expect(locations[0][:type]).to eq("City of")
			end
		end 

		context "county search" do 
			it "locates and identifies the county" do 
				locations = @service.find_regions("Santa Clara County")
				expect(locations[0][:description]).to eq("Santa Clara, CA, United States")
				expect(locations[0][:id]).to eq("1019a381cf34eb999ba02adcfeaf3f066d662fb1")
				expect(locations[0][:type]).to eq("County of")
			end

		end 

		context "state search" do 
			it "locates and identifies the state" do 
				locations = @service.find_regions("California")
				expect(locations[0][:description]).to eq("California, United States")
				expect(locations[0][:id]).to eq("b993df4055071925c7950dc2afd22c0b98f994e0")
				expect(locations[0][:type]).to eq("State of")
			end

		end

		context "country search" do 
			it "locates and identifies the country" do 
				locations = @service.find_regions("United States")
				expect(locations[0][:description]).to eq("United States")
				expect(locations[0][:id]).to eq("88564d30369b045e767b90442f46a1245864c58f")
				expect(locations[0][:type]).to eq("Country of")
			end
		end 

		context "district search" do 
			it "locates and does not return entry" do 
				locations = @service.find_regions("Hampton Beach")
				expect(locations[0][:description]).to eq("Hampton Beach, Hampton, NH, United States")
				expect(locations[0][:id]).to eq("5f59aebc53bba8ff82b7dc98ea629977e58ebaf8")
				expect(locations[0][:type]).to eq("District of")
			end
		end
	end	

end
