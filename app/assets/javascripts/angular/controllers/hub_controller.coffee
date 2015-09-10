HubController = ['$scope', '$rootScope', '$location', '$http', 'SelectHubLoader', 'Hub', 'svUtility', ($scope, $rootScope, $location, $http, SelectHubLoader, Hub, svUtility) ->

  $scope.disabled = undefined

  $scope.enable = ->
    $scope.disabled = false

  $scope.disable = ->
    $scope.disabled = true

  $scope.clear = ($event) ->
    $event.stopPropagation()
    $scope.sessionSettings.hub_attributes = null
    $location.search('hub', null)
    $scope.sessionSettings.actions.hubShow = true

  $scope.refreshHubs = (hub_filter) ->
    if hub_filter.length > 1
      params =
        hub_filter: hub_filter
      SelectHubLoader(hub_filter).then (response) ->
        $scope.hubs = response

  $rootScope.setHub = (item, model) ->
    if item.isTag and item.full_hub.length >= $scope.sessionSettings.spokenvote_attributes.minimumHubNameLength
      if not $scope.currentUser.id
        $scope.authService.signinFb($scope).then ->
          $scope.votingService.new()  unless $location.path() is '/start'
          svUtility.focus '#hub_formatted_location'
      else
        $scope.votingService.new()  unless $location.path() is '/start'
        $scope.sessionSettings.actions.hintShow = false
        svUtility.focus '#hub_formatted_location'
    else if item.isTag
      $scope.sessionSettings.hub_attributes = null
    else
      item.id = item.select_id
      $location.search 'hub', item.id
      if $scope.sessionSettings.actions.hubSeekOnSearch is true
        $location.path '/proposals'
      else
        $scope.votingService.commentStep()

  $scope.createSearchChoice = (newHub) ->
    console.log 'newHub in HubController: ', newHub
    {full_hub: newHub}

  $scope.tagTransform = (newTag) ->
    item = undefined
    if $scope.sessionSettings.hub_attributes
      item =
        full_hub: newTag
        location_id: $scope.sessionSettings.hub_attributes.location_id
        formatted_location: $scope.sessionSettings.hub_attributes.formatted_location
    else
      item =
        full_hub: newTag
    item

  $scope.finishProp = ->
    $scope.sessionSettings.actions.hintShow = false
    if $scope.sessionSettings.newVote.statement and $scope.sessionSettings.hub_attributes
      $scope.sessionSettings.actions.focus = 'comment'
      svUtility.focus '#new_vote_comment'
    else
      svUtility.focus '#new_proposal_statement'
    console.log 'finishProp: '
]

App.controller 'HubController', HubController