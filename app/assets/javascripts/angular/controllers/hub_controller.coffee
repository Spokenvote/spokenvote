HubController = ['$scope', '$rootScope', '$log', '$http', 'SelectHubLoader', 'Hub', ($scope, $rootScope, $log, $http, SelectHubLoader, Hub) ->

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
    $rootScope.sessionSettings.hub_attributes = item
    $rootScope.sessionSettings.hub_attributes.id = item.select_id
  #    $scope.sessionSettings.actions.changeHub = false
  #    $scope.sessionSettings.actions.selectHub = true
#    $log.log 'hi from setHub', item

  $scope.createSearchChoice = (newHub) ->
    console.log 'newHub: ', newHub
    {full_hub: newHub}

#  $scope.clearFilter = (filter) ->
#    $location.search(filter, null)
#    $rootScope.sessionSettings.routeParams.user = null

]

App.controller 'HubController', HubController