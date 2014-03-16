alertBar = [ '$parse', '$rootScope', ($parse, $rootScope) ->
  restrict: 'A'
  templateUrl: '/assets/shared/_request_response_partial.html'

  link: (scope, elem, attrs) ->
    alertMessageAttr = attrs['alertmessageclear']
#    scope.errorMessage = null                       #Alternate method using local scope copy of alert
#    scope.$watch alertMessageAttr, (newVal) ->
#      scope.errorMessage = newVal

#    scope.hideAlert = ->
    $rootScope.hideAlert = ->
#      scope.errorMessage = null                     #Alternate method using local scope copy of alert
      $parse(alertMessageAttr).assign scope, null
]

App.Directives.directive 'alertBar', alertBar