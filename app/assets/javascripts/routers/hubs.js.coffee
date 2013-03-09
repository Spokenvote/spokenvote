app.Routers.Hubs = Backbone.Router.extend(
  routes:
    "": "index"

  index: ->
    collection = new app.Collections.Hubs()
    view = new app.Views.Hubs(collection: collection)
    collection.fetch()
    $('#hubModal').find('#hub_group_name').val(searchGroup);
    $('#hubModal').modal();
    $("#mainContent").html view.render().el
)