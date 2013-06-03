svGooglePlace = ->
  require: "ngModel"
  link: (scope, element, attrs, model) ->
    model.$parsers.unshift ->
      model.$setValidity "location", false

    defaultBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(72.501722, -172.617188)
      new google.maps.LatLng(14.604847, -61.171875)
    )

    options =
      bounds: defaultBounds
      types: ['(regions)']
    autocomplete = new google.maps.places.Autocomplete(element[0], options)
    google.maps.event.addListener autocomplete, "place_changed", ->
      location = autocomplete.getPlace()
      scope.selectedLocation = location      #TODO Refactor existing to format below
      scope.hub_attributes.location_id = location.id
      scope.hub_attributes.formatted_location = location.formatted_address

      model.$setValidity "location", true
#      scope.$apply ->
#        scope.updateModel()

App.Directives.directive 'svGooglePlace', svGooglePlace