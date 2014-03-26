#App.controller 'UserSettingsCtrl', [ '$scope', '$modalInstance', 'CurrentUser', ($scope, $modalInstance, CurrentUser) ->
App.controller 'UserSettingsCtrl', ($scope, $modalInstance, CurrentUser) ->

#UserSettingsCtrl = ($scope, $modalInstance, CurrentUser) ->

  console.log $modalInstance

  $scope.saveUserSettings = ->
    $scope.newSupport.proposal_id = $scope.clicked_proposal.id
    $scope.alertService.clearAlerts()

    CurrentUser.save($scope.currentUser
    ,  (response, status, headers, config) ->
#      $rootScope.$broadcast 'event:votesChanged'
      $scope.alertService.setSuccess $scope.currentUser.first_name + '\'s settings have been updated.', $scope, 'main'
      $modalInstance.close(response)
    ,  (response, status, headers, config) ->
      $scope.alertService.setCtlResult 'Sorry, ' + $scope.currentUser.first_name + ' your settings were not saved.', $scope, 'modal'
      $scope.alertService.setJson response.data
    )


# Injects
#UserSettingsCtrl.$inject = [ '$scope', '$cookieStore', '$location', 'SessionService', 'AlertService', 'CurrentUser' ]

# Register
#App.controller 'UserSettingsCtrl', UserSettingsCtrl
