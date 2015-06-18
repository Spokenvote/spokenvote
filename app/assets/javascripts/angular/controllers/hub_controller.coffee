HubController = ['$scope', '$rootScope', '$location', '$http', 'SelectHubLoader', 'Hub', 'Focus', ($scope, $rootScope, $location, $http, SelectHubLoader, Hub, Focus) ->

  $scope.disabled = undefined

  $scope.enable = ->
    $scope.disabled = false

  $scope.disable = ->
    $scope.disabled = true

  $scope.minNewHubLength = $scope.sessionSettings.spokenvote_attributes.minNewHubLength

  $scope.clear = ($event) ->
#    console.log '... clear ...: '
    $event.stopPropagation()
    $scope.sessionSettings.hubFilter = undefined
#    $scope.sessionSettings.hub_attributes = null     Jun 17, 2015 Not sure, trying to remove this.
    $location.search('hub', null)
#    $location.search('hub', null) if $location.path() == '/proposals'
    $scope.sessionSettings.actions.hubFilter = 'All Groups'
    $scope.sessionSettings.actions.hubShow = true

  $scope.refreshHubs = (hub_filter) ->
    if hub_filter.length > 1
      params =
        hub_filter: hub_filter
      SelectHubLoader(hub_filter).then (response) ->
        $scope.hubs = response

  $rootScope.setHub = (item, model) ->
    console.log 'setHub: ', item.full_hub.length
    if item.isTag and item.full_hub.length >= $scope.minNewHubLength
      console.log 'isTag: $scope.sessionSettings.hub_attributes', $scope.sessionSettings.hub_attributes
#      $scope.sessionSettings.actions.hubCreate = true    # TODO Eliminating actions.hubCreate
      currentHub = $scope.sessionSettings.hub_attributes
      $scope.sessionSettings.hub_attributes =
        group_name: item.full_hub
        location_id: currentHub.location_id
        formatted_location: currentHub.formatted_location
      if !$scope.currentUser.id?
        $scope.authService.signinFb($scope).then ->
          $scope.votingService.new()  unless $location.path() == '/start'
#          $scope.sessionSettings.actions.changeHub = 'new'
          $scope.sessionSettings.actions.hubCreate = item.full_hub    # TODO Eliminating actions.hubCreate
          Focus '#hub_formatted_location'
      else
        $scope.votingService.new()  unless $location.path() is '/start'
#        $scope.sessionSettings.actions.changeHub = 'new'
        $scope.sessionSettings.actions.hubCreate = item.full_hub    # TODO Eliminating actions.hubCreate
#        console.log '$scope.sessionSettings.actions.changeHub: ', $scope.sessionSettings.actions.changeHub
        Focus '#hub_formatted_location'
    else if item.isTag
      $scope.sessionSettings.hubFilter = null
    else
      $rootScope.eventResult = {item: item, model: model}      # What does this line do?
      item.id = item.select_id
      $rootScope.sessionSettings.hub_attributes = item
      $scope.sessionSettings.actions.hubShow = true
      $location.search('hub', item.id)
      $location.path('/proposals')  unless $location.path() == '/start'
      #    $location.path('/proposals').search('hub', item.id)  unless $location.path() == '/start'
      $scope.sessionSettings.actions.hubFilter = $scope.sessionSettings.hub_attributes.short_hub    # Need this?
#      $scope.sessionSettings.actions.changeHub = false
  #    $scope.sessionSettings.actions.selectHub = true


  $scope.createSearchChoice = (newHub) ->
    console.log 'newHub in HubController: ', newHub
    {full_hub: newHub}

  $scope.tagTransform = (newTag) ->
#    console.log 'newTag: ', newTag
    item =
      full_hub: newTag
    item

#  $scope.clearFilter = (filter) ->
#    $location.search(filter, null)
#    $rootScope.sessionSettings.routeParams.user = null

]

App.controller 'HubController', HubController