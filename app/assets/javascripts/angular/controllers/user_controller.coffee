app = angular.module "spokenvote" #method required by ngmin DI annotation gem
app.controller 'UserSettingsCtrl', ($scope, $modalInstance, CurrentUser) ->

  $scope.saveUserSettings = ->
#    $scope.newSupport.proposal_id = $scope.clicked_proposal.id
    $scope.alertService.clearAlerts()

    CurrentUser.save $scope.currentUser, ((response, status, headers, config) ->
#      $rootScope.$broadcast 'event:votesChanged'
      $scope.alertService.setSuccess $scope.currentUser.first_name + "'s settings have been updated.", $scope, "main"
      $modalInstance.close response
    ), (response, status, headers, config) ->
      $scope.alertService.setCtlResult "Sorry, " + $scope.currentUser.first_name + " your settings were not saved.", $scope, "modal"
      $scope.alertService.setJson response.data

# Register
#App.controller 'UserSettingsCtrl', UserSettingsCtrl
