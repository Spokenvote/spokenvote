app.Views.Hubs = Backbone.View.extend(
  template: JST["hubs/new"]
#  events:
#    "click #hubSorter a": "fetchProposalsWithParams"

  initialize: ->
    @model.on "reset", @render.bind(this)

  render: ->
    @$el.html @template(hubs: @model.toJSON())
    this

  fetchProposalsWithParams: (event) ->
    event.preventDefault()
    target = $(event.target)
    @model.fetch data: $.param(filter: target.data("hubs-type"))
    target.addClass "active"
)