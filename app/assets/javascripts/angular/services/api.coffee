#angular.module("hubs", ["ngResource"]).factory "Hub", ['$resource', ($resource) ->
#  Hub = $resource("/hubs/:id", {id: "@id"}, {update: {method: "PUT"}})
#]

angularApp.factory "Hub", ($resource) ->
  $resource("/hubs/:id", {id: "@id"}, {update: {method: "PUT"}})

angularApp.factory "Proposal", ($resource) ->
  $resource("/proposals/:id", {id: "@id"}, {update: {method: "PUT"}})
