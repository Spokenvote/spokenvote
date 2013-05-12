services = angular.module('spokenvote.services')

ErrorService = ->
  errorMessage: null
  setError: (msg) ->
    console.log "setError: " + msg
    @errorMessage = msg

  clear: ->
    @errorMessage = null

services.factory 'ErrorService', ErrorService

  # registers an interceptor for ALL angular ajax http calls
errorHttpInterceptor = ($q, $location, ErrorService, $rootScope) ->
  (promise) ->
    promise.then ((response) ->
      ErrorService.setError "Kim's forced message: " + response.status
      response
    ), (response) ->
      if response.status is 401 || 406
        $rootScope.$broadcast "event:loginRequired"
      else ErrorService.setError "Server was unable to find what you were looking for... Sorry!!"  if response.status >= 200 and response.status < 500
      $q.reject response

errorHttpInterceptor.$inject = [ '$q', '$location', 'ErrorService', '$rootScope'  ]
services.factory 'errorHttpInterceptor', errorHttpInterceptor


HubSelected = ->
  group_name: "All Groups"
  id: "No id yet"

services.factory 'HubSelected', HubSelected

SpokenvoteCookies = ($cookies) ->
  $cookies.SpokenvoteSession = "Setting a value6"
  sessionCookie: $cookies.SpokenvoteSession

SpokenvoteCookies.$inject = [ '$cookies' ]
services.factory 'SpokenvoteCookies', SpokenvoteCookies
