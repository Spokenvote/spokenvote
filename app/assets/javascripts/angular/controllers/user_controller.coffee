UserSettingsCtrl = ($scope, $cookieStore, $location, SessionService, AlertService, dialog, CurrentUser) ->
  console.log $scope.sessionSettings

  $scope.saveUserSettings = ->
    $scope.newSupport.proposal_id = $scope.clicked_proposal.id
    AlertService.clearAlerts()

    CurrentUser.save($scope.currentUser
    ,  (response, status, headers, config) ->
#      $rootScope.$broadcast 'event:votesChanged'
      AlertService.setSuccess $scope.currentUser.first_name + '\'s settings have been updated.', $scope, 'main'
      dialog.close(response)
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, ' + $scope.currentUser.first_name + ' your settings were not saved.', $scope, 'modal'
      AlertService.setJson response.data
    )

  $scope.close = (result) ->
    dialog.close(result)

# Injects
UserSettingsCtrl.$inject = [ '$scope', '$cookieStore', '$location', 'SessionService', 'AlertService', 'dialog', 'CurrentUser' ]

# Register
App.controller 'UserSettingsCtrl', UserSettingsCtrl
