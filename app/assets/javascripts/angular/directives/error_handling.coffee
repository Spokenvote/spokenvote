alertBar = [ '$parse', '$rootScope', ($parse, $rootScope) ->
  restrict: 'A'
  templateUrl: 'shared/_request_response_partial.html'

  link: (scope, elem, attrs) ->
    alertMessageAttr = attrs['alertmessageclear']

    $rootScope.hideAlert = ->
      $parse(alertMessageAttr).assign scope, null
]

App.Directives.directive 'alertBar', alertBar