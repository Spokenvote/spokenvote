# Rest
Vote = ($resource) ->
  $resource("/votes/:id", {id: "@id"}, {update: {method: "PUT"}})

Hub = ($resource) ->
  $resource("/hubs/:id", {id: "@id"}, {update: {method: "PUT"}})

Proposal = ($resource) ->
  $resource("/proposals/:id", {id: "@id"}, {update: {method: "PUT"}})

# Non-rest
CurrentUser = ($resource) ->
  $resource("/currentuser")

RelatedProposals = ($resource) ->
  $resource("/proposals/:id/related_proposals?related_sort_by=:related_sort_by",
    { id: "@id" },
    { related_sort_by: "@related_sort_by" }
  )

RelatedVoteInTree = ($resource) ->
  $resource("/proposals/:id/related_vote_in_tree", {id: "@id"})

# Resources
UserOmniauthResource = ($http) ->
  UserOmniauth = (options) ->
    angular.extend this, options

  UserOmniauth::$save = ->
    $http.get "/users/auth/facebook",
#      provider: @provider

  UserOmniauth::$destroy = ->
    $http.delete "/users/logout"

  UserOmniauth

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

# Loaders
CurrentUserLoader = (CurrentUser, $route, $q) ->
  ->
    delay = $q.defer()
    CurrentUser.get {}
    , (current_user) ->
      delay.resolve current_user
    , ->
      delay.reject 'Unable to locate a current user '
    delay.promise

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

#UserOmniauth = ($resource) ->
#  $resource("/users/auth/:provider", {provider: "@provider"})
#
#App.Services.factory 'UserOmniauth', UserOmniauth
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
#App.Services.factory 'UserOmniauthCallback', UserOmniauthCallback

# Injects
Vote.$inject = [ '$resource' ]
Hub.$inject = [ '$resource' ]
Proposal.$inject = [ '$resource' ]

CurrentUser.$inject = [ '$resource' ]
RelatedProposals.$inject = [ '$resource' ]
RelatedVoteInTree.$inject = [ '$resource' ]
# UserOmniauth.$inject = [ '$resource' ]

UserOmniauthResource.$inject = [ '$http' ]
UserSessionResource.$inject = [ '$http' ]
UserRegistrationResource.$inject = [ '$http' ]

CurrentUserLoader.$inject = [ 'CurrentUser', '$route', '$q' ]
ProposalLoader.$inject = [ 'Proposal', '$route', '$q' ]
MultiProposalLoader.$inject = [ 'Proposal', '$route', '$q' ]
RelatedProposalsLoader.$inject = [ 'RelatedProposals', '$route', '$q' ]
RelatedVoteInTreeLoader.$inject = [ 'RelatedVoteInTree', '$q' ]
# UserOmniauthCallback.$inject = [ 'UserOmniauth', '$route', '$q' ]

# Register
App.Services.factory 'Vote', Vote
App.Services.factory 'Hub', Hub
App.Services.factory 'Proposal', Proposal

App.Services.factory 'CurrentUser', CurrentUser
App.Services.factory 'RelatedProposals', RelatedProposals
App.Services.factory 'RelatedVoteInTree', RelatedVoteInTree

App.Services.factory 'UserOmniauthResource', UserOmniauthResource
App.Services.factory 'UserSessionResource', UserSessionResource
App.Services.factory 'UserRegistrationResource', UserRegistrationResource

App.Services.factory 'CurrentUserLoader', CurrentUserLoader
App.Services.factory 'ProposalLoader', ProposalLoader
App.Services.factory 'MultiProposalLoader', MultiProposalLoader
App.Services.factory 'RelatedProposalsLoader', RelatedProposalsLoader
App.Services.factory 'RelatedVoteInTreeLoader', RelatedVoteInTreeLoader