app.Routers.Hubs = Backbone.Router.extend(
  routes:
    "": "index"

  index: ->
    collection = new app.Collections.Hubs()
    view = new app.Views.Hubs(collection: collection)
    collection.fetch()
    $("#mainContent").html view.render().el
)