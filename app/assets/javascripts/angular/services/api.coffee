# Resources
CurrentUser = ($resource) ->
  $resource '/currentuser'

Hub = ($resource) ->
  $resource '/hubs/:id', {id: '@id'}, {update: {method: 'PUT'} }

Vote = ($resource) ->
  $resource '/votes/:id', id: '@id', { update: method: 'PUT' }

Proposal = ($resource) ->
  $resource '/proposals/:id', id: '@id', { update: method: 'PUT' }

RelatedProposals = ($resource) ->
  $resource '/proposals/:id/related_proposals?related_sort_by=:related_sort_by',
    id: '@id'
    related_sort_by: '@related_sort_by'

RelatedVoteInTree = ($resource) ->
  $resource '/proposals/:id/related_vote_in_tree',
    id: '@id'

UserOmniauthResource = ($http) ->
  UserOmniauth = (options) ->
    angular.extend this, options

  UserOmniauth::$save = ->
    $http.post '/authentications',
      auth: @auth

  UserOmniauth::$destroy = ->
    $http.delete "/users/logout"

  UserOmniauth

UserSessionResource = ($http) ->
  UserSession = (options) ->
    angular.extend this, options

#  UserSession::$save = ->                 #not current in use
#    $http.post "/users/login",
#      user:
#        email: @email
#        password: @password
#        remember_me: (if @remember_me then 1 else 0)

#  UserSession::$destroy = ->
#    $http.delete "/users/logout"

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
    CurrentUser.get(
      ({}
      ), ((current_user) ->
        delay.resolve current_user
      ), ->
        delay.reject 'Unable to locate a current user '
    )
    delay.promise

SelectHubLoader = (Hub, $route, $q) ->
  (params) ->
    delay = $q.defer()
    if params
      Hub.get(
        (params: params
        ), ((hubs) ->
          delay.resolve hubs
        ), ->
          delay.reject 'Unable to locate a hub '
      )
    else
      delay.resolve false
    delay.promise

CurrentHubLoader = (Hub, $route, $q) ->
  ->
    delay = $q.defer()
    if $route.current.params.hub
      Hub.get(
        (id: $route.current.params.hub
        ), ((hub) ->
          delay.resolve hub
        ), ->
          delay.reject 'Unable to locate a hub '
      )
    else
      delay.resolve false
    delay.promise

ProposalLoader = (Proposal, $route, $q) ->
  ->
    delay = $q.defer()
    Proposal.get(
      (id: $route.current.params.proposalId
      ), ((proposal) ->
        delay.resolve proposal
      ), ->
        delay.reject 'Unable to locate proposal ' + $route.current.params.proposalId
    )
    delay.promise

MultiProposalLoader = [ 'Proposal', '$route', '$q', '$http', (Proposal, $route, $q, $http) ->
  ->
#    console.log 'prop: ', Proposal.query
    delay = $q.defer()
#    Proposal.query
    $http(
      url: "/proposals"
#      id: '@id'
      method: "GET"
      params:
        hub: $route.current.params.hub
        filter: $route.current.params.filter
        user: $route.current.params.user
#    , (proposals) ->
    ).success((proposals) ->
      delay.resolve proposals
#    , ->
    ).error ->
      delay.reject 'Unable to locate proposals for hub' + $route.current.params.hub
    delay.promise
]

RelatedProposalsLoader = (RelatedProposals, $route, $q) ->
  ->
    delay = $q.defer()
    RelatedProposals.get(
      (
        id: $route.current.params.proposalId
        related_sort_by:  $route.current.params.related_sort_by
      ), ((related_proposals) ->
        delay.resolve related_proposals
      ), ->
        delay.reject 'Unable to locate related proposals ' + $route.current.params.proposalId
    )
    delay.promise

RelatedVoteInTreeLoader = (RelatedVoteInTree, $q) ->
  (clicked_proposal) ->
    delay = $q.defer()
    RelatedVoteInTree.get(
      ( id: clicked_proposal.id
      ), ((related_voteInTree) ->
        delay.resolve related_voteInTree
      ), ->
        delay.reject 'Unable to find any related votes in the tree for proposal: ' + clicked_proposal.id
      )
    delay.promise

# Injects
CurrentUser.$inject = [ '$resource' ]
Hub.$inject = [ '$resource' ]
Vote.$inject = [ '$resource' ]
Proposal.$inject = [ '$resource' ]
RelatedProposals.$inject = [ '$resource' ]
RelatedVoteInTree.$inject = [ '$resource' ]

UserOmniauthResource.$inject = [ '$http' ]
UserSessionResource.$inject = [ '$http' ]
UserRegistrationResource.$inject = [ '$http' ]

CurrentUserLoader.$inject = [ 'CurrentUser', '$route', '$q' ]
CurrentHubLoader.$inject = [ 'Hub', '$route', '$q' ]
ProposalLoader.$inject = [ 'Proposal', '$route', '$q' ]
#MultiProposalLoader.$inject = [ 'Proposal', '$route', '$q' ]
RelatedProposalsLoader.$inject = [ 'RelatedProposals', '$route', '$q' ]
RelatedVoteInTreeLoader.$inject = [ 'RelatedVoteInTree', '$q' ]
# UserOmniauthCallback.$inject = [ 'UserOmniauth', '$route', '$q' ]

# Register
App.Services.factory 'CurrentUser', CurrentUser
App.Services.factory 'Hub', Hub
App.Services.factory 'Vote', Vote
App.Services.factory 'Proposal', Proposal

App.Services.factory 'CurrentHubLoader', CurrentHubLoader
App.Services.factory 'SelectHubLoader', SelectHubLoader
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