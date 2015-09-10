StartController = [ '$scope', 'svUtility', 'CurrentHubLoader', ( $scope, svUtility, CurrentHubLoader ) ->
#  console.log 'StartController: '
  $scope.alertService.clearAlerts()
  $scope.sessionSettings.actions.hubSeekOnSearch = false
  $scope.sessionSettings.actions.hubPlaceholder = 'Who should see your proposal? ...'
  $scope.sessionSettings.actions.newVoteDetails.propStepText = 'You have 140 characters to state your proposal.'
  if $scope.sessionSettings.hub_attributes
    $scope.sessionSettings.actions.hubShow = true
  else
    $scope.sessionSettings.actions.hubShow = false
#  $scope.sessionSettings.actions.hubShow = false  unless $scope.sessionSettings.hub_attributes or $scope.sessionSettings.actions.newVoteDetails.proposalStarted
#  $scope.sessionSettings.actions.newVoteDetails.proposalStarted = true
  $scope.sessionSettings.newVote = {}

# When would I want this? Seems confusing to keep previously authored work around.
#  if $scope.sessionSettings.newVote.statement and $scope.sessionSettings.hub_attributes
#    $scope.sessionSettings.actions.focus = 'comment'
#    svUtility.focus '#new_vote_comment'
#  else
#    svUtility.focus '#new_proposal_statement'

  svUtility.focus '#new_proposal_statement'
]
App.controller 'StartController', StartController
