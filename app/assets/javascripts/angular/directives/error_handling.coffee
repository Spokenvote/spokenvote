alertBar = ($parse) ->
  restrict: 'A'
  templateUrl: '/assets/shared/_request_response_partial.html'

  link: (scope, elem, attrs) ->
    alertMessageAttr = attrs['alertmessageclear']
#    scope.errorMessage = null                       #Alternate method using local scope copy of alert
#    scope.$watch alertMessageAttr, (newVal) ->
#      scope.errorMessage = newVal

    scope.hideAlert = ->
#      scope.errorMessage = null                     #Alternate method using local scope copy of alert
      $parse(alertMessageAttr).assign scope, null

alertBar.$inject = [ '$parse' ]
App.Directives.directive 'alertBar', alertBar