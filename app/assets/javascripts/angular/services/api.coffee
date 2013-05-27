services = angular.module('spokenvote.services')

CurrentUser = ($resource) ->
  $resource("/currentuser")

services.factory 'CurrentUser', CurrentUser

CurrentUserLoader = (CurrentUser, $route, $q) ->
  ->
    delay = $q.defer()
    CurrentUser.get {}
    , (current_user) ->
      delay.resolve current_user
    , ->
      delay.reject 'Unable to locate a current user '
    delay.promise

services.factory 'CurrentUserLoader', CurrentUserLoader


#UserOmniauth = ($resource) ->
#  $resource("/users/auth/:provider", {provider: "@provider"})
#
#services.factory 'UserOmniauth', UserOmniauth
#
#UserOmniauthCallback = (UserOmniauth, $route, $q) ->
#  ( provider )->
#    delay = $q.defer()
#    UserOmniauth.save
#      provider: provider
#    , (user_auth) ->
#      delay.resolve user_auth
#    , ->
#      delay.reject 'Unable to authorize a current user '
#    delay.promise
#
#services.factory 'UserOmniauthCallback', UserOmniauthCallback


UserOmniauthResource = ($http) ->
  UserOmniauth = (options) ->
    angular.extend this, options

  UserOmniauth::$save = ->
    $http.get "/users/auth/facebook",
#      provider: @provider

  UserOmniauth::$destroy = ->
    $http.delete "/users/logout"

  UserOmniauth

services.factory 'UserOmniauthResource', UserOmniauthResource


UserSessionResource = ($http) ->
  UserSession = (options) ->
    angular.extend this, options

  UserSession::$save = ->
    $http.post "/users/login",
      user:
        email: @email
        password: @password
        remember_me: (if @remember_me then 1 else 0)

  UserSession::$destroy = ->
    $http.delete "/users/logout"

  UserSession

services.factory 'UserSessionResource', UserSessionResource

UserRegistrationResource = ($http) ->
  UserRegistration = (options) ->
    angular.extend this, options

  UserRegistration::$save = ->
    $http.post "/users",
      user:
        name: @name
        email: @email
        password: @password
        password_confirmation: @password_confirmation

  UserRegistration

services.factory 'UserRegistrationResource', UserRegistrationResource


Vote = ($resource) ->
  $resource("/votes/:id", {id: "@id"}, {update: {method: "PUT"}})

services.factory 'Vote', Vote


Hub = ($resource) ->
  $resource("/hubs/:id", {id: "@id"}, {update: {method: "PUT"}})

services.factory 'Hub', Hub


Proposal = ($resource) ->
  $resource("/proposals/:id", {id: "@id"}, {update: {method: "PUT"}})

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

services.factory 'MultiProposalLoader', MultiProposalLoader

ProposalLoader = (Proposal, $route, $q) ->
  ->
    delay = $q.defer()
    Proposal.get
      id: $route.current.params.proposalId
    , (proposal) ->
      delay.resolve proposal
    , ->
      delay.reject 'Unable to locate proposal ' + $route.current.params.proposalId
    delay.promise

services.factory 'ProposalLoader', ProposalLoader


RelatedProposals = ($resource) ->
  $resource("/proposals/:id/related_proposals?related_sort_by=:related_sort_by", {id: "@id"}, {related_sort_by: "@related_sort_by"})

services.factory 'RelatedProposals', RelatedProposals

RelatedProposalsLoader = (RelatedProposals, $route, $q) ->
  ->
    delay = $q.defer()
    RelatedProposals.get
      id: $route.current.params.proposalId
      related_sort_by:  $route.current.params.related_sort_by
    , (related_proposals) ->
      delay.resolve related_proposals
    , ->
      delay.reject 'Unable to locate related proposals ' + $route.current.params.proposalId
    delay.promise

services.factory 'RelatedProposalsLoader', RelatedProposalsLoader


RelatedVoteInTree = ($resource) ->
  $resource("/proposals/:id/related_vote_in_tree", {id: "@id"})

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

services.factory 'RelatedVoteInTreeLoader', RelatedVoteInTreeLoader