class app.Views.Hubs extends Backbone.View
  template: JST['hubs/show']

  initialize: ->
    @collection.on "reset", @render, this

  render: ->
#    @($el).html(@template(hubs: @model.toJSON()))
    @$el.html @template(hubs: @collection)
    this
#  $(@el).html(@template(hubs: "stuff here"))

#  fetchProposalsWithParams: (event) ->
#    event.preventDefault()
#    target = $(event.target)
#    @model.fetch data: $.param(filter: target.data("hubs-type"))
#    target.addClass "active"
