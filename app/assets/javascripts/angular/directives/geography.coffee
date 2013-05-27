directives = angular.module('spokenvote.directives')

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
      scope.selectedLocation = autocomplete.getPlace()
      model.$setValidity "location", true
      scope.$apply ->
        scope.updateModel()

directives.directive 'svGooglePlace', svGooglePlace
