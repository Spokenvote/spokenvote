StartController = [ '$scope', '$location', 'Focus', '$timeout', '$http', ( $scope, $location, Focus, $timeout, $http ) ->
  $scope.alertService.clearAlerts()
#  $scope.sessionSettings.actions.newProposal.hub = 'waiting'  unless $scope.sessionSettings.hub_attributes.id
  $scope.sessionSettings.actions.newProposal.started = true
  $scope.sessionSettings.actions.hubPlaceholder = 'Who should see your proposal? ...'
#  $scope.sessionSettings.hub_attributes.id = null
#  $scope.sessionSettings.actions.newProposalHub = null
#  $scope.sessionSettings.actions.newProposal.focus = 'prop'
#  console.log '$scope.sessionSettings.actions.newProposal: ', $scope.sessionSettings.actions.newProposal
  #  $scope.sessionSettings.actions.changeHub = true
#  $scope.sessionSettings.actions.wizardToGroup = null

  uiSelect = angular.element 'ui-select-wrapper'
#  console.log 'uiSelect: ', uiSelect.focusser[0]

  Focus 'proposal_statement'

  $scope.commentStep = ->
#    $scope.sessionSettings.actions.newProposal.prop = 'complete'
    $scope.sessionSettings.actions.newProposal.comment = 'active'
#    $scope.sessionSettings.actions.newProposal.focus = 'comment'
    Focus 'vote_comment'
  #    Focus('comment-text')

  $scope.hubStep = ->
    $scope.sessionSettings.actions.newProposal.comment = 'complete'
    $scope.sessionSettings.actions.newProposal.hub = 'active'  unless $scope.sessionSettings.hub_attributes.id
    console.log '$scope.sessionSettings.actions.newProposal.comment: ', $scope.sessionSettings.actions.newProposal.comment
    if $scope.newProposalForm.$valid
      $scope.sessionSettings.actions.newProposal.focus = 'publish'
      Focus 'publish'
    else
  #    $scope.sessionSettings.actions.newProposal.hub = 'active' if $scope.sessionSettings.actions.newProposal.hub isnt 'complete'
  #    Focus('vote_hub')
  #    uiSelect.focusser[0].focus()
  #    Focus('ui-select-search')

  $scope.finishProp = ->
#    console.log 'hi from finishProp '
    $scope.sessionSettings.actions.newProposal.hub = 'complete'
    Focus 'publish'

  #    $scope.sessionSettings.actions.newProposal.focus = 'none'
#    Focus('vote_hub')
#    Focus('ui-select-search')

  $scope.goToGroup = (action) ->
    if $scope.sessionSettings.hub_attributes.id?
#      $location.path('/proposals').search('hub', $scope.sessionSettings.hub_attributes.id).hash('navigationBar')      # Angular empty hash bug
      $scope.sessionSettings.actions.hubFilter = $scope.sessionSettings.hub_attributes.group_name
      $scope.sessionSettings.actions.wizardToGroup = action
]

App.controller 'StartController', StartController
