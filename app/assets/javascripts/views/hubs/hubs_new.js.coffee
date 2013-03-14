class app.Views.HubsNew extends Backbone.View
  template: JST["hubs/new"]

  events:
    'hubModalSave #new_hub': 'createEntry'

  initialize: ->
    @collection.on "reset", @render, this

  render: ->
    @$el.html @template(hubs: @collection.toJSON())
    this

  createEntry: (event) ->
    event.preventDefault()
    @collection.create name: $('#group_name').val()

#    target = $(event.target)
#    @model.fetch data: $.param(filter: target.data("hubs-type"))
#    target.addClass "active"
