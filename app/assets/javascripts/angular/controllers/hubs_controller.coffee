HubsCtrl = ($scope, Hub) ->
  $scope.modal = {content: 'Hello Modal', saved: false};    # part of angular-strap concept
  $scope.newHub = {}
  $scope.newHub.group_name = $scope.searchGroupTerm
#  console.log $scope.searchGroupTerm

  $scope.addHub = ->
    $scope.addhub_result = null
    $scope.jsonErrors = null
    $scope.addhub_alert = false
    if $scope.selectedLocation? and
       $scope.selectedLocation != null and
       $scope.newHub.formatted_location == $scope.selectedLocation.formatted_address
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
      $scope.addhub_result = "Please select a Location from the provided list"

    $scope.addhub_alert = true

  $scope.clearHub = ->
    $scope.newHub = null
    $scope.addhub_result = null
    $scope.jsonErrors = null
    $scope.addhub_alert = false
    $scope.modal.saved = false

  $scope.updateModel = ->
    $scope.newHub.formatted_location = $scope.selectedLocation.formatted_address
    $scope.newHub.location_id = $scope.selectedLocation.id

HubsCtrl.$inject = ['$scope', 'Hub']
angularApp.controller 'HubsCtrl', HubsCtrl