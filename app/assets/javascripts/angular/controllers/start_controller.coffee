StartController = [ '$scope', 'svUtility', ( $scope, svUtility ) ->
  $scope.alertService.clearAlerts()
  $scope.sessionSettings.actions.hubSeekOnSearch = false
  $scope.sessionSettings.actions.hubPlaceholder = 'Who should see your proposal? ...'
  $scope.sessionSettings.actions.newVoteDetails.propStepText = 'You have 140 characters to state your proposal.'
  if $scope.sessionSettings.hub_attributes
    $scope.sessionSettings.actions.hubShow = true
  else
    $scope.sessionSettings.actions.hubShow = false
#  $scope.sessionSettings.actions.hubShow = false  unless $scope.sessionSettings.hub_attributes or $scope.sessionSettings.actions.newVoteDetails.proposalStarted
  $scope.sessionSettings.newVote = {}
  svUtility.focus '#new_proposal_statement'
]
App.controller 'StartController', StartController
