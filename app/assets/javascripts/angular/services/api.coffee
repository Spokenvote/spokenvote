services = angular.module('spokenvote.services', ['ngResource'])

services.factory "Hub", ($resource) ->
  $resource("/hubs/:id", {id: "@id"}, {update: {method: "PUT"}})

services.factory 'Proposal', ($resource) ->
  $resource("/proposals/:id", {id: "@id"}, {update: {method: "PUT"}})

services.factory 'MultiProposalLoader', (Proposal, $route, $q) ->
  ->
    delay = $q.defer()
    Proposal.query
      hub: $route.current.params.hub
      filter: $route.current.params.filter
    , (proposals) ->
      delay.resolve proposals
    , ->
      delay.reject 'Unable to fetch proposals ' + '$route.current.params.proposalId'
    delay.promise

services.factory.$inject = [ 'Proposal', '$route', '$q' ]
# TODO check with Wagner here, as I'm not sure I'm doing these injects correctly.

services.factory 'ProposalLoader', (Proposal, $route, $q) ->
  ->
    delay = $q.defer()
    Proposal.get
      id: $route.current.params.proposalId
    , (proposal) ->
      delay.resolve proposal
    , ->
      delay.reject 'Unable to fetch proposal ' + $route.current.params.proposalId
    delay.promise

services.factory.$inject = [ 'Proposal', '$route', '$q' ]
# TODO check with Wagner here, as I'm not sure I'm doing these injects correctly.