modalCtrl = ($scope, parentScope, $cookieStore, $location, SessionSettings, AlertService, dialog) ->
  AlertService.clearAlerts()
  $scope.parentScope = parentScope
  $scope.dialog = dialog

  $scope.close = (result) ->
    dialog.close(result)

GetStartedCtrl = ($scope, $cookieStore, $location, SessionSettings) ->
  $scope.sessionSettings.hub_attributes = null
#  $scope.sessionSettings.actions.searchTerm = null
  $scope.sessionSettings.actions.newProposalHub = null
  $scope.sessionSettings.actions.changeHub = true

  $scope.changeHub = (request) ->
    if request = true and $scope.sessionSettings.actions.changeHub != 'new'
      $scope.sessionSettings.actions.changeHub = !$scope.sessionSettings.actions.changeHub

  $scope.tooltips =
    newHub: "You may change the group to which you are directing
                      this proposal by clicking here."

  $scope.goToGroup = ->
    if SessionSettings.hub_attributes.id?
      $location.path('/proposals').search('hub', SessionSettings.hub_attributes.id)
      SessionSettings.actions.hubFilter = SessionSettings.hub_attributes.group_name
      $scope.close()

# Injects
modalCtrl.$inject = [ '$scope', 'parentScope', '$cookieStore', '$location', 'SessionSettings', 'AlertService', 'dialog' ]
GetStartedCtrl.$inject = [ '$scope', '$cookieStore', '$location', 'SessionSettings' ]

# Register
App.controller 'modalCtrl', modalCtrl
App.controller 'GetStartedCtrl', GetStartedCtrl
