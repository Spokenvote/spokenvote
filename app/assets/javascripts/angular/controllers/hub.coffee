@HubCtrl = ($scope, Hub, FormatAlert) ->
  $scope.hubs = Hub.query()

  $scope.addHub = ->
    hub = Hub.save($scope.newHub
    ,  (data, status, headers, config) ->
      $scope.alertclass = 'alert alert-#success'
      $scope.addhub_result = "The " + hub.group_name + " group was created."
    ,  (data, status, headers, config) ->
      group_name_error = if data.data.group_name? then " Group Name  " + data.data.group_name else ""
      location_error = if data.data.formatted_location? then " Location " + data.data.formatted_location else ""
      $scope.alertclass = 'alert alert-#error'
      $scope.addhub_result = group_name_error + location_error
#      console.log(data)
#      console.log(data.data)
#      console.log(data.data.group_name)
#      console.log(data.data.location_id)
#      console.log(data.status)
    )

#    $scope.hubs.push(hub)
#    $scope.newHub = {}







