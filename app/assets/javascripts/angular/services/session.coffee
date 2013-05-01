services = angular.module('spokenvote.services')

services.factory "HubSelected", ->
  group_name: "All Groups"
  id: "No id yet"

#services.factory "HubProposals", ->
#  []

#services.factory "HubProposals", ($resource, $routeParams, Proposal) ->
#  hubProposals = Proposal.query
#    filter: $routeParams.filter
#    hub: $routeParams.search
#  hubProposals

#  services.factory.$inject = [ ]
