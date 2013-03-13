class app.Views.HubsIndex extends Backbone.View
  template: JST['hubs/index']

  events:
    'submit #new_entry': 'createEntry'

  initialize: ->
    @collection.on "reset", @render, this
    @collection.on "add", @render, this

  render: ->
    @$el.html @template(hubs: @collection.toJSON())
    this

  createEntry: (event) ->
    event.preventDefault()
    @collection.create group_name: $('#new_entry_name').val
    @collection.create formatted_location: $('#new_location_name').val
