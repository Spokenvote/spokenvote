class app.Routers.Proposals extends Backbone.Router
  routes:
    "": "index"

  index: ->
    collection = new app.Collections.Proposals()
    view = new app.Views.ProposalsIndex(collection: collection)
    collection.fetch()
    $("#mainContent").html view.render().el