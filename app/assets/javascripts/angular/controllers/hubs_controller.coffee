angularApp.controller "HubsCtrl", ($scope, Hub) ->
  $scope.hubs = Hub.query()

  $scope.addHub = ->
    if $scope.selectedLocation?
      $scope.newHub.formatted_location = $scope.selectedLocation.formatted_address
      $scope.newHub.location_id = $scope.selectedLocation.id
      hub = Hub.save($scope.newHub

      ,  (response, status, headers, config) ->
        $scope.alertclass = 'ngalert alert-success'
        $scope.addhub_result = "The " + hub.group_name + " group was created."
        $scope.newHub = {}
        $("#hubModal").modal('hide')

      ,  (response, status, headers, config) ->
        $scope.alertclass = 'ngalert alert-error'

        if(response.status == 406)
          $scope.addhub_result = "You must be logged in"
        else
          $scope.jsonErrors = response.data
      )
    else
      $scope.alertclass = 'ngalert alert-error'
      $scope.addhub_result = "Please select a Location for your Group"
