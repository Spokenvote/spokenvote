StartController = [ '$scope', '$location', 'Focus', '$timeout', ( $scope, $location, Focus, $timeout ) ->
  $scope.alertService.clearAlerts()
#  $scope.sessionSettings.hub_attributes.id = null
#  $scope.sessionSettings.actions.newProposalHub = null
  $scope.sessionSettings.actions.newProposal.prop = 'active'
  console.log '$scope.sessionSettings.actions.newProposal: ', $scope.sessionSettings.actions.newProposal
  #  $scope.sessionSettings.actions.changeHub = true
  $scope.sessionSettings.actions.wizardToGroup = null

  Focus('proposal_statement')
#  $timeout ->
#    jQuery ->
#      $('#newProposalHub').select2('open')
#      $('#newProposalHub').select2('focus', true)

  $scope.commentStep = ->
    $scope.sessionSettings.actions.newProposal.prop = 'complete'
    $scope.sessionSettings.actions.newProposal.comment = 'active'
    Focus('vote_comment')

  $scope.hubStep = ->
    $scope.sessionSettings.actions.newProposal.comment = 'complete'
    $scope.sessionSettings.actions.newProposal.hub = 'active'
    Focus('vote_hub')

  $scope.goToGroup = (action) ->
    if $scope.sessionSettings.hub_attributes.id?
      $location.path('/proposals').search('hub', $scope.sessionSettings.hub_attributes.id).hash('navigationBar')
      $scope.sessionSettings.actions.hubFilter = $scope.sessionSettings.hub_attributes.group_name
      $scope.sessionSettings.actions.wizardToGroup = action

]

App.controller 'StartController', StartController
