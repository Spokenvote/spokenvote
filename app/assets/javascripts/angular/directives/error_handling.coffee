directives = angular.module('spokenvote.directives')

alertBar = ($parse) ->
  restrict: "A"
  template: '<div class="alert alert-error alert-bar" ng-show="errorMessage">' +
  '<button type="button" class="close" ng-click="hideAlert()">x</button>' +
  '{{errorMessage}}</div>'
  link: (scope, elem, attrs) ->
    alertMessageAttr = attrs["alertmessage"]
    scope.errorMessage = null
    scope.$watch alertMessageAttr, (newVal) ->
      scope.errorMessage = newVal

    scope.hideAlert = ->
      scope.errorMessage = null
      $parse(alertMessageAttr).assign scope, null

alertBar.$inject = [ '$parse' ]
directives.directive 'alertBar', alertBar