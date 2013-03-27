app = angular.module("Spokenvote", ["ngResource"])

app.factory "Hub", ($resource) ->
  $resource("/hubs/:id", {id: "@id"}, {update: {method: "PUT"}})

#TODO I do not believe this setting is necessary and can be deleted
#app.config ["$httpProvider", ($httpProvider) ->
#  $httpProvider.defaults.headers.post['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
#]

#TODO Below is just sandbox code that may be deleted when we fully uderstand Angular Services
app.factory "FormatAlert", ->
  msg = "msg text"
  message: "<div class=\"alert alert-" + 'style' + "\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\">&times;</a>" + msg + "</div>."
