HubController = ['$scope', '$rootScope', '$log', ($scope, $rootScope, $log) ->


  $rootScope.setHub = (item, model) ->
    $rootScope.eventResult = {item: item, model: model}
    $rootScope.sessionSettings.hub_attributes = item
    $log.log 'hi from setHub', item


#  $scope.clearFilter = (filter) ->
#    $location.search(filter, null)
#    $rootScope.sessionSettings.routeParams.user = null

]

App.controller 'HubController', HubController