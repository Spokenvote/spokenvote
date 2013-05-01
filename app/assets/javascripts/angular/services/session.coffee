services = angular.module('spokenvote.services')

services.factory "HubSelected", ->
  group_name: "All Groups"
  id: "No id yet"

services.factory "SpokenvoteCookies", ($cookies) ->
  $cookies.SpokenvoteSession = "Setting a value6"
  sessionCookie: $cookies.SpokenvoteSession

services.factory.$inject = [ '$cookies' ]
