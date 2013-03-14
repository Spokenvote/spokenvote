class app.Routers.Hubs extends Backbone.Router
  routes:
    'hubs': 'index'
    'hubs/:id': 'show'
    '/hubs/new/': 'new'

  initialize: ->
    @collection = new app.Collections.Hubs()
    @collection.fetch()

  index: ->
#    collection = new app.Collections.Hubs()
    view = new app.Views.HubsIndex(collection: @collection)
    $('#mainContent').html(view.render().el)

#    collection.fetch()
#    $('#hubModal').find('#hub_group_name').val(searchGroup);
#    $('#hubModal').modal();
#    $("#mainContent").html view.render().el

  show: (id) ->
    view = new app.Views.Hubs()
    $('#mainContent').html(view.render().el)

  new: ->
    view = new app.Views.HubsNew(collection: @collection)
    $('#mainContent').html(view.render().el)


