'use strict'

appConfig = ['$routeProvider', '$locationProvider', '$httpProvider', '$modalProvider', ($routeProvider, $locationProvider, $httpProvider, $modalProvider) ->
]

# Some code under test
window.plus = (a, b) ->
  a + b

# this one is not coveraged
window.minus = (a, b) ->
  a - b