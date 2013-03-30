angularApp.controller "HubCtrl", ($scope, Hub, HubFilter) ->
  $scope.hubs = Hub.query()

  $scope.addHub = ->
    if $scope.selectedLocation?
      $scope.newHub.formatted_location = $scope.selectedLocation.formatted_address
      $scope.newHub.location_id = $scope.selectedLocation.id
      hub = Hub.save($scope.newHub
      ,  (response, status, headers, config) ->
        $scope.alertclass = 'alert alert-#success'
        $scope.addhub_result = "The " + hub.group_name + " group was created."
      ,  (response, status, headers, config) ->
        $scope.alertclass = 'alert alert-#error'
        $scope.jsonErrors = response.data)
    else
      $scope.alertclass = 'alert alert-#error'
      $scope.addhub_result = "Please select a Location for your Group"
