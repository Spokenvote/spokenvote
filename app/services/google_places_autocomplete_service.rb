# This service class provides APIs to talk to the Google Places Autocomplete service 

class GooglePlacesAutocompleteService

	# Service requires an API key that should be set in application's environment variable
	def initialize
		@client = GooglePlacesAutocomplete::Client.new(api_key: ENV['GOOGLE_API_KEY'])
	end

	# Finds cities, counties, states and countries matching the passed in search string
	def find_regions(search_string) 
		results = []
    autocomplete = @client.autocomplete(input: search_string, types: "(regions)")
    autocomplete.predictions.each do |p|
    	location_type = get_type_for_location(p.types[0])
    	results << { type: location_type, id: p.id, description: p.description } if location_type
    end
    results
	end

  def self.location_types 
    ["All of", "City of", "County of", "State of", "Country of", "District of"]
  end

  def self.prefix
    "GL-"
  end

	private 
	
	# Provides translation of location types returned by google apis to ones our app desires
	# namely (city, county, state and country)
	def get_type_for_location location
		case location
     	when "locality"
     		"City of"
     	when "administrative_area_level_2" 
     		"County of"
   		when "administrative_area_level_1"
   			"State of"
   		when "country"
   			"Country of"
      when "sublocality"
        "District of"
   		else
   			nil
   		end
    end

end
