$.extend app,
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new app.Routers.Proposals()
    new app.Routers.Hubs()
    Backbone.history.start() #pushState: true .. seems to interfere with /#hubs rout

$(document).ready ->
  app.setPageHeight()
  app.initialize()