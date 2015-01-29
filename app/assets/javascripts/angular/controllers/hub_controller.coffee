HubController = ['$scope', '$rootScope', '$location', '$http', 'SelectHubLoader', 'Hub', ($scope, $rootScope, $location, $http, SelectHubLoader, Hub) ->

  $scope.disabled = undefined

  $scope.enable = ->
    $scope.disabled = false

  $scope.disable = ->
    $scope.disabled = true

  $scope.clear = ($event) ->
    $event.stopPropagation()
    $scope.sessionSettings.hubFilter = undefined
    $location.search('hub', null) if $location.path() == '/proposals'
    $scope.sessionSettings.actions.hubFilter = 'All Groups'


  $scope.refreshHubs = (hub_filter) ->
    if hub_filter.length > 1
      params =
        hub_filter: hub_filter

#      Hub.query(                   # Using $Resource, question pending
#        (params: params
#        ), ((hubs) ->
#          $log.log hubs
#          $scope.hubs = hubs
#        ), ->
#          'Unable to locate a hub '
#      )

      SelectHubLoader(hub_filter).then (response) ->
#        $log.log response
        $scope.hubs = response


  $rootScope.setHub = (item, model) ->
    $rootScope.eventResult = {item: item, model: model}      # What does this line do?
    item.id = item.select_id
    $rootScope.sessionSettings.hub_attributes = item

#    $scope.sessionSettings.actions.selectHub = false
    $location.search('hub', item.id)
    $location.path('/proposals')  unless $location.path() == '/start'
    $scope.sessionSettings.actions.hubFilter = $scope.sessionSettings.hub_attributes.short_hub    # Need this?
  #    $scope.sessionSettings.actions.changeHub = false
  #    $scope.sessionSettings.actions.selectHub = true

  $scope.createSearchChoice = (newHub) ->
    console.log 'newHub: ', newHub
    {full_hub: newHub}

#  $scope.clearFilter = (filter) ->
#    $location.search(filter, null)
#    $rootScope.sessionSettings.routeParams.user = null

]

App.controller 'HubController', HubController