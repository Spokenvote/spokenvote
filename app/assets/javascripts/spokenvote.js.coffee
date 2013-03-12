$.extend app,
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new app.Routers.Proposals()
    new app.Routers.Hubs()
    Backbone.history.start pushState: true

$(document).ready ->
  app.setPageHeight()
  app.initialize()