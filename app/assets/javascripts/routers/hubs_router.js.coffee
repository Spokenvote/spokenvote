class app.Routers.Hubs extends Backbone.Router
  routes:
#    'hubs/': 'index'
#    '/hub/new/': 'build'
    'hubs/:id': 'show'

  index: ->
    collection = new app.Collections.Hubs()
    view = new app.Views.Hubs(collection: collection)
    collection.fetch()
#    $('#hubModal').find('#hub_group_name').val(searchGroup);
#    $('#hubModal').modal();
    $("#mainContent").html view.render().el

  show: (id) ->
    view = new app.Views.Hubs()
    $('#container').html(view.render().el)

  build: ->
    view = new app.Views.Hubs()
    $('#modal-body').html(view.render().el)


