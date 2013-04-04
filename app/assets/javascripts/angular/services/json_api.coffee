angularApp.factory "Hub", ($resource) ->
  $resource("/hubs/:id", {id: "@id"}, {update: {method: "PUT"}})
