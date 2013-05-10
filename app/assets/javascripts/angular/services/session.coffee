services = angular.module('spokenvote.services')

ErrorService = ->
  errorMessage: null
  setError: (msg) ->
    @errorMessage = msg

  clear: ->
    @errorMessage = null

services.factory 'ErrorService', ErrorService


HubSelected = ->
  group_name: "All Groups"
  id: "No id yet"

services.factory 'HubSelected', HubSelected


SpokenvoteCookies = ($cookies) ->
  $cookies.SpokenvoteSession = "Setting a value6"
  sessionCookie: $cookies.SpokenvoteSession

SpokenvoteCookies.$inject = [ '$cookies' ]
services.factory 'SpokenvoteCookies', SpokenvoteCookies
