directives = angular.module('spokenvote.directives')

alertBar = ($parse) ->
  restrict: "A"
  template: '<div class="alert alert-error alert-bar" ng-show="errorService.errorMessage">' +
  '<button type="button" class="close" ng-click="hideAlert()">x</button>' +
  '<ul><span>' + '{{ errorService.errorMessage }}' + '</span></ul>' +
  '<ul><span>' + '{{ errorService.cltActionResult }}' + '</span></ul>' +
  '<ul><span ng-repeat="(key, values) in errorService.jsonErrors">' +
  '<ul ng-show="errorService.jsonErrors" ng-repeat="value in values">' +
  '{{ errorService.jsonErrors }}' +
  '</span> </ul> </div>'
  link: (scope, elem, attrs) ->
    alertMessageAttr = attrs["alertmessage"]
    scope.errorService.errorMessage = null
    scope.$watch alertMessageAttr, (newVal) ->
      scope.errorService.errorMessage = newVal

    scope.hideAlert = ->
      scope.errorService.errorMessage = null
      $parse(alertMessageAttr).assign scope, null

alertBar.$inject = [ '$parse' ]
directives.directive 'alertBar', alertBar