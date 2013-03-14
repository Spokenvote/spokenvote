class app.Views.ProposalsIndex extends Backbone.View
  template: JST["proposals/index"]
  events:
    "click #hubSorter a": "fetchProposalsWithParams"

  initialize: ->
    @collection.on "reset", @render.bind(this)

  render: ->
    @$el.html @template(proposals: @collection.toJSON())
    this

  fetchProposalsWithParams: (event) ->
    event.preventDefault()
    target = $(event.target)
    @collection.fetch data: $.param(filter: target.data("proposals-type"))
    target.addClass "active"
