modalCtrl = ($scope, parentScope, $location, SessionSettings, AlertService, dialog) ->
  AlertService.clearAlerts()
  $scope.parentScope = parentScope
  $scope.dialog = dialog

  $scope.close = (result) ->
    dialog.close(result)

  $scope.changeHub = (request) ->
    if request = true and $scope.sessionSettings.actions.changeHub != 'new'
      $scope.sessionSettings.actions.changeHub = !$scope.sessionSettings.actions.changeHub

  $scope.tooltips =
    newHub: "You may change the group to which you are directing
                          this proposal by clicking here."


GetStartedCtrl = ($scope, $location, SessionSettings) ->
  $scope.sessionSettings.hub_attributes.id = null
  $scope.sessionSettings.actions.newProposalHub = null
  $scope.sessionSettings.actions.changeHub = true

  $scope.goToGroup = (action) ->
    if SessionSettings.hub_attributes.id?
      $location.path('/proposals').search('hub', SessionSettings.hub_attributes.id)
      SessionSettings.actions.hubFilter = SessionSettings.hub_attributes.group_name
      $scope.sessionSettings.actions.wizardToGroup = action

# Injects
modalCtrl.$inject = [ '$scope', 'parentScope', '$location', 'SessionSettings', 'AlertService', 'dialog' ]
GetStartedCtrl.$inject = [ '$scope', '$location', 'SessionSettings' ]

# Register
App.controller 'modalCtrl', modalCtrl
App.controller 'GetStartedCtrl', GetStartedCtrl
