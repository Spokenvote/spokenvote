angularApp.factory "HubFilter", ->
  group_name: "No Group has yet been specified"

angularApp.factory "HubSelected", ->
  group_name: "All Groups"
  id: "No id yet"

angularApp.factory "HubProposals", ->
  []

#angularApp.factory "HubProposals", ($resource, $routeParams, Proposal) ->
#  hubProposals = Proposal.query
#    filter: $routeParams.filter
#    hub: $routeParams.search
#  hubProposals

# Serices with passing params look like this?
#angularApp.factory "HubProposals", ($resource, $routeParams, Proposal) ->
#  hubProposals = (input) ->
#    Proposal.query
#      filter: $routeParams.filter
#      hub: $routeParams.search
#    hubProposals

