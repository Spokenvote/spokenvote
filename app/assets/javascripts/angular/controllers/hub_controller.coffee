HubController = ['$scope', '$rootScope', '$log', '$http', 'SelectHubLoader', 'Hub', ($scope, $rootScope, $log, $http, SelectHubLoader, Hub) ->

  $scope.disabled = `undefined`

  $scope.enable = ->
    $scope.disabled = false

  $scope.disable = ->
    $scope.disabled = true

  $scope.clear = ->
    $scope.address.selected = `undefined`

  $scope.hubFilter = {}
  $scope.refreshHubs = (hub_filter) ->
    if hub_filter.length > 1
      params =
        hub_filter: hub_filter

#      Hub.query(
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

#      $http.get("/hubs",
#        params: params
#      ).then (response) ->
#        $scope.hubs = response.data


  $rootScope.setHub = (item, model) ->
    $rootScope.eventResult = {item: item, model: model}
    $rootScope.sessionSettings.hub_attributes = item
#    $log.log 'hi from setHub', item


#  $scope.clearFilter = (filter) ->
#    $location.search(filter, null)
#    $rootScope.sessionSettings.routeParams.user = null

]

App.controller 'HubController', HubController