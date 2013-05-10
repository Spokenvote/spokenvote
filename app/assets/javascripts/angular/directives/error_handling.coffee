directives = angular.module('spokenvote.directives')

svGooglePlace = ->
  link: (scope, element, attrs, model) ->
    defaultBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(72.501722, -172.617188)
      new google.maps.LatLng(14.604847, -61.171875))

    options =
      bounds: defaultBounds
      types: ['(regions)']
    autocomplete = new google.maps.places.Autocomplete(element[0], options)
    google.maps.event.addListener autocomplete, "place_changed", ->
      scope.selectedLocation = autocomplete.getPlace()
      scope.$apply ->
        scope.updateModel()

directives.directive 'svGooglePlace', svGooglePlace

#angular.module("myApp.directives", []).directive "alertBar", [ "$parse", ($parse) ->
#  restrict: "A"
#  template: "<div class=\"alert alert-error alert-bar\"" + "ng-show=\"errorMessage\">" + "<button type=\"button\" class=\"close\" ng-click=\"hideAlert()\">" + "x</button>" + "{{errorMessage}}</div>"
#  link: (scope, elem, attrs) ->
#    alertMessageAttr = attrs["alertmessage"]
#    scope.errorMessage = null
#    scope.$watch alertMessageAttr, (newVal) ->
#      scope.errorMessage = newVal
#
#    scope.hideAlert = ->
#      scope.errorMessage = null
#]