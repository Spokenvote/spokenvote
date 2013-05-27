directives = angular.module('spokenvote.directives')

alertBar = ($parse) ->
  restrict: 'A'
  templateUrl: '/assets/shared/_request_response_partial.html.haml'
  link: (scope, elem, attrs) ->
    alertMessageAttr = attrs['alertmessageclear']
#    scope.errorMessage = null                       #Alternate method using local scope copy of alert
#    scope.$watch alertMessageAttr, (newVal) ->
#      scope.errorMessage = newVal

    scope.hideAlert = ->
#      scope.errorMessage = null                     #Alternate method using local scope copy of alert
      $parse(alertMessageAttr).assign scope, null

directives.directive 'alertBar', alertBar