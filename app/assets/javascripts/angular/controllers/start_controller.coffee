#StartController = [ '$scope', '$location', 'Focus', '$timeout', '$route', 'proposal', ( $scope, $location, Focus, $timeout, $route, proposal ) ->
StartController = [ '$rootScope', '$scope', '$location', 'Focus', '$timeout', '$route', ( $rootScope, $scope, $location, Focus, $timeout, $route ) ->
#  console.log 'StartController restarting'
#  $scope.proposal = proposal
  $scope.alertService.clearAlerts()

  #  $scope.sessionSettings.actions.hubShow = false  unless $route.current.params.hub or $scope.sessionSettings.actions.newProposal.started
  $scope.sessionSettings.actions.hubShow = false  unless $scope.sessionSettings.hub_attributes or $scope.sessionSettings.actions.newProposal.started
#  $scope.sessionSettings.actions.hubShow = false  unless $scope.sessionSettings.hub_attributes.full_hub or $scope.sessionSettings.actions.newProposal.started
#  $scope.sessionSettings.actions.hubShow = false  unless $scope.sessionSettings.routeParams.hub or $scope.sessionSettings.actions.newProposal.started
  $scope.sessionSettings.actions.newProposal.started = true
  $scope.sessionSettings.actions.hubPlaceholder = 'Who should see your proposal? ...'

  #  $scope.sessionSettings.actions.newProposal.hub = 'waiting'  unless $scope.sessionSettings.hub_attributes.id
  #  $scope.sessionSettings.hub_attributes.id = null
#  $scope.sessionSettings.actions.newProposalHub = null
#  console.log '$scope.sessionSettings.actions.newProposal: ', $scope.sessionSettings.actions.newProposal
  #  $scope.sessionSettings.actions.changeHub = true
#  $scope.sessionSettings.actions.wizardToGroup = null

  if $scope.sessionSettings.newProposal.statement? and $scope.sessionSettings.hub_attributes?
    $scope.sessionSettings.actions.focus = 'publish'
    Focus '#publish'
  else
    Focus '#proposal_statement'

  $scope.commentStep = ->
    $scope.sessionSettings.actions.newProposal.comment = 'active'
    Focus '#vote_comment'

#  $rootScope.$on 'focusHubFilter', ->
#    console.log '$rootScope: focusHubFilter Triggered line 44'

  $scope.hubStep = ->
    $scope.sessionSettings.actions.newProposal.comment = 'complete'
    $scope.sessionSettings.actions.focus = 'hub'
    $scope.sessionSettings.actions.hubShow = true
    #    $scope.sessionSettings.actions.newProposal.hub = 'active'  unless $scope.sessionSettings.hub_attributes.id
    if $scope.sessionSettings.hub_attributes
#    if $scope.newProposalForm.$valid and $scope.sessionSettings.hub_attributes.id
      if $scope.newProposalForm.$valid
        $scope.sessionSettings.actions.focus = 'publish'
        Focus '#publish'
      else
        $scope.alertService.setError 'The proposal is not quite right, too short perhaps?', $scope, 'main'
    else
      $rootScope.$broadcast 'focusHubFilter'

  $rootScope.finishProp = ->
    console.log 'finishProp: '
    $scope.sessionSettings.actions.newProposal.hub = 'complete'
    $scope.sessionSettings.actions.focus = 'publish'
    $timeout (-> Focus '#publish'), 500

]

App.controller 'StartController', StartController
