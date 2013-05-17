services = angular.module('spokenvote.services')

CurrentUser = ($resource) ->
  $resource("/currentuser")

CurrentUser.$inject = [ '$resource' ]
services.factory 'CurrentUser', CurrentUser

UserSession = ($resource) ->
  $resource("/users/login",
    user:
      email: @email
      password: @password
      remember_me: (if @remember_me then 1 else 0))

UserSession.$inject = [ '$resource' ]
services.factory 'UserSession', UserSession

UserRegistration = ($http) ->
  UserReg = (options) ->
    angular.extend this, options

  UserReg::$save = ->
    $http.post "/users",
      user:
        email: @email
        password: @password
        password_confirmation: @password_confirmation

  UserReg

UserRegistration.$inject = [ '$http' ]
services.factory 'UserRegistration', UserRegistration

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


Vote = ($resource) ->
  $resource("/votes/:id", {id: "@id"}, {update: {method: "PUT"}})

Vote.$inject = [ '$resource' ]
services.factory 'Vote', Vote


Hub = ($resource) ->
  $resource("/hubs/:id", {id: "@id"}, {update: {method: "PUT"}})

Hub.$inject = [ '$resource' ]
services.factory 'Hub', Hub


Proposal = ($resource) ->
  $resource("/proposals/:id", {id: "@id"}, {update: {method: "PUT"}})

Proposal.$inject = [ '$resource' ]
services.factory 'Proposal', Proposal


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


RelatedVoteInTree = ($resource) ->
  $resource("/proposals/:id/related_vote_in_tree", {id: "@id"})

RelatedVoteInTree.$inject = [ '$resource' ]
services.factory 'RelatedVoteInTree', RelatedVoteInTree

RelatedVoteInTreeLoader = (RelatedVoteInTree, $q) ->
  (clicked_proposal_id) ->
    delay = $q.defer()
    RelatedVoteInTree.get
      id: clicked_proposal_id
    , (relatedVoteInTree) ->
      delay.resolve relatedVoteInTree
      , ->
      delay.reject 'Unable to find any related votes in the tree for proposal: ' + clicked_proposal_id
    delay.promise

RelatedVoteInTreeLoader.$inject = [ 'RelatedVoteInTree', '$q' ]
services.factory 'RelatedVoteInTreeLoader', RelatedVoteInTreeLoader

