HubController = ['$scope', '$rootScope', '$location', '$http', 'SelectHubLoader', 'Hub', 'Focus', ($scope, $rootScope, $location, $http, SelectHubLoader, Hub, Focus) ->

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
#    console.log '$scope.sessionSettings.hub_attributes: ', $scope.sessionSettings.hub_attributes
    if item.isTag and item.full_hub.length >= $scope.sessionSettings.spokenvote_attributes.minimumHubNameLength
#      console.log 'isTag: $scope.sessionSettings.hub_attributes', $scope.sessionSettings.hub_attributes
      if not $scope.currentUser.id
        $scope.authService.signinFb($scope).then ->
          $scope.votingService.new()  unless $location.path() == '/start'
          Focus '#hub_formatted_location'
      else
        $scope.votingService.new()  unless $location.path() is '/start'
        Focus '#hub_formatted_location'
    else if item.isTag
      $scope.sessionSettings.hub_attributes = null
    else
#      $rootScope.eventResult = {item: item, model: model}      # What does this line do?
      item.id = item.select_id
      $location.search('hub', item.id)
      $location.path('/proposals')  if $scope.sessionSettings.actions.hubSeekOnSearch is true
  #      $location.path('/proposals')  unless $location.path() is '/start'

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
]

App.controller 'HubController', HubController