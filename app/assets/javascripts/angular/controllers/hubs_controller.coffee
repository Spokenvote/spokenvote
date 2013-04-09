angularApp.controller "HubsCtrl", ($scope, Hub) ->
#  $scope.hubs = Hub.query()
  $scope.modal = {content: 'Hello Modal', saved: false};    # part of angular-strap - possible future use

  $scope.addHub = ->
    $scope.addhub_result = null
    $scope.jsonErrors = null
    $scope.addhub_alert = false
    if $scope.selectedLocation? and $scope.selectedLocation != null
      $scope.newHub.formatted_location = $scope.selectedLocation.formatted_address
      $scope.newHub.location_id = $scope.selectedLocation.id
      hub = Hub.save($scope.newHub
                          #TODO Error handling needs to be refactored into a Service
      ,  (response, status, headers, config) ->
        $scope.alertclass = 'ngalert alert-success'
        $scope.addhub_result = "Your " + hub.group_name + " group was created."
        $scope.modal.saved = true

      ,  (response, status, headers, config) ->
        $scope.alertclass = 'ngalert alert-error'

        if(response.status == 406)
          $scope.addhub_result = "You must be logged in"
        else
          $scope.jsonErrors = response.data
      )
    else
      $scope.alertclass = 'ngalert alert-error'
      $scope.addhub_result = "Invalid Location selected for your Group"

    $scope.addhub_alert = true

  $scope.clearHub = ->
    $scope.newHub = null
    $scope.addhub_result = null
    $scope.jsonErrors = null
    $scope.addhub_alert = false
    $scope.modal.saved = false
