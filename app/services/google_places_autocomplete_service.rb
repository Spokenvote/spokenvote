# This service class provides APIs to talk to the Google Places Autocomplete service 

class GooglePlacesAutocompleteService
  
  def initialize 
    raise ArgumentError, "GOOGLE_API_KEY is undefined" if !ENV['GOOGLE_API_KEY'] 
  end

	# Finds cities, counties, states and countries matching the passed in search string
	def find_regions(search_string) 
		results = []
    autocomplete = places_api.autocomplete(input: search_string, types: "(regions)")
    autocomplete.predictions.each do |p|
    	location_type = get_type_for_location(p.types[0])
    	results << { type: location_type, id: p.id, description: p.description, reference: p.reference } if location_type
    end
    results
	end

  def self.location_types 
    ["All of", "City of", "County of", "State of", "Country of", "District of"]
  end

  def self.prefix
    "GL-"
  end

  def get_place_details(reference)
    if details = details_api.details(reference: reference)
      location_type = get_type_for_location(details.result.types[0])   
      location_type && { type: location_type, id: details.result.id, 
        description: details.result.formatted_address, reference: reference }
    else 
      nil 
    end
  end

	private 
	
  # returns client to access google places autocomplete apis which allow us to 
  # search for locations by city, county, state, country and district
  def places_api
    @places_api ||= GooglePlacesAutocomplete::Client.new(api_key: ENV['GOOGLE_API_KEY'])
  end

  # returns client to access google places details api which allows us to find out 
  # details for a place based on a reference value returned earlier from the google api
  # (we need this to look up details for locations found using google apis that were 
  # bookmarked by users)
  def details_api 
    @details_api ||= Places::Client.new(api_key: ENV['GOOGLE_API_KEY'])
  end

	# Provides translation of location types returned by google apis to ones our app desires
	# namely (city, county, state and country)
	def get_type_for_location location
    location_type_name = {
      "locality" => "City",
      "administrative_area_level_2" => "County",
      "administrative_area_level_1" => "State",
      "country" => "Country",
      "sublocality" => "District",
      "sublocality_level_1" => "District"
      }[location]

    location_type_name && "#{location_type_name} of"
  end

end
