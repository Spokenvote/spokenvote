services = angular.module('spokenvote.services')

services.factory "CurrentUser", ($resource) ->
  $resource("/currentuser")

CurrentUserLoader = (CurrentUser, $route, $q) ->
  ->
    delay = $q.defer()
    CurrentUser.get {}
    , (current_user) ->
      delay.resolve current_user
    , ->
      delay.reject 'Unable to locate a current user '
    delay.promise

CurrentUserLoader.$inject = [ 'CurrentUser', '$route', '$q' ]
services.factory 'CurrentUserLoader', CurrentUserLoader


services.factory "Vote", ($resource) ->
  $resource("/votes/:id", {id: "@id"}, {update: {method: "PUT"}})


services.factory "Hub", ($resource) ->
  $resource("/hubs/:id", {id: "@id"}, {update: {method: "PUT"}})


services.factory 'Proposal', ($resource) ->
  $resource("/proposals/:id", {id: "@id"}, {update: {method: "PUT"}})

MultiProposalLoader = (Proposal, $route, $q) ->
  ->
    delay = $q.defer()
    Proposal.query
      hub: $route.current.params.hub
      filter: $route.current.params.filter
    , (proposals) ->
      delay.resolve proposals
    , ->
      delay.reject 'Unable to locate proposals ' + $route.current.params.proposalId
    delay.promise

MultiProposalLoader.$inject = [ 'Proposal', '$route', '$q' ]
services.factory 'MultiProposalLoader', MultiProposalLoader

ProposalLoader = (Proposal, $route, $q) ->
  ->
    delay = $q.defer()
    Proposal.get
      id: $route.current.params.proposalId
    , (proposal) ->
      delay.resolve proposal
    , ->
      delay.reject 'Unable to fetch proposal ' + $route.current.params.proposalId
    delay.promise

ProposalLoader.$inject = [ 'Proposal', '$route', '$q' ]
services.factory 'ProposalLoader', ProposalLoader
