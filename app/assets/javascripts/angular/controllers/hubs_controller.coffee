HubsCtrl = ($scope, Hub, AlertService) ->
  $scope.hub_attributes = {}
  $scope.hub_attributes.group_name = $scope.searchGroupTerm


  $scope.addHub = ->
    AlertService.clearAlerts()
    if $scope.hub_attributes.formatted_location?

      Hub.save($scope.hub_attributes
      ,  (response, status, headers, config) ->
#        $scope.Hub.$get()        # Currently we don't show a list of hubs, but might at some point.
        AlertService.setSuccess 'Your new group \"' + response.group_name + '\" was created.', $scope
        $scope.dismiss()
      ,  (response, status, headers, config) ->
        AlertService.setCtlResult 'Sorry, your new group was not saved.', $scope
        AlertService.setJson response.data
      )

    else
      AlertService.setCtlResult 'Please select a Location from the provided list.', $scope

  $scope.updateModel = ->
    $scope.hub_attributes.formatted_location = $scope.selectedLocation.formatted_address
    $scope.hub_attributes.location_id = $scope.selectedLocation.id

HubsCtrl.$inject = ['$scope', 'Hub', 'AlertService']
App.controller 'HubsCtrl', HubsCtrl