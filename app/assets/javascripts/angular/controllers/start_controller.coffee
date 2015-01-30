StartController = [ '$scope', '$location', 'Focus', '$timeout', '$http', '$route', ( $scope, $location, Focus, $timeout, $http, $route ) ->
  console.log 'StartController restarting'
  $scope.alertService.clearAlerts()
#  $scope.sessionSettings.actions.newProposal.hub = 'waiting'  unless $scope.sessionSettings.hub_attributes.id
  $scope.sessionSettings.actions.hubShow = false  unless $route.current.params.hub or $scope.sessionSettings.actions.newProposal.started
  $scope.sessionSettings.actions.newProposal.started = true
  $scope.sessionSettings.actions.hubPlaceholder = 'Who should see your proposal? ...'
#  $scope.sessionSettings.hub_attributes.id = null
#  $scope.sessionSettings.actions.newProposalHub = null
#  console.log '$scope.sessionSettings.actions.newProposal: ', $scope.sessionSettings.actions.newProposal
  #  $scope.sessionSettings.actions.changeHub = true
#  $scope.sessionSettings.actions.wizardToGroup = null

  uiSelect = angular.element 'ui-select-wrapper'
#  console.log 'uiSelect: ', uiSelect.focusser[0]

#  focusser = angular.element "<input class='ui-select-focusser ui-select-offscreen' type='text' aria-haspopup='true' role='button' />"
#  console.log 'focusser focus: ', focusser.focus()

  if $scope.sessionSettings.newProposal.statement? and $scope.sessionSettings.hub_attributes?
    $scope.sessionSettings.actions.focus = 'publish'
    Focus 'publish'
  else
    Focus 'proposal_statement'

  $scope.commentStep = ->
#    $scope.sessionSettings.actions.newProposal.prop = 'complete'
    $scope.sessionSettings.actions.newProposal.comment = 'active'
#    $scope.sessionSettings.actions.focus = 'comment'
    Focus 'vote_comment'
  #    Focus('comment-text')

  $scope.hubStep = ->
    $scope.sessionSettings.actions.newProposal.comment = 'complete'
    $scope.sessionSettings.actions.newProposal.hub = 'active'  unless $scope.sessionSettings.hub_attributes.id
#    console.log '$scope.sessionSettings.actions.newProposal.comment: ', $scope.sessionSettings.actions.newProposal.comment
    if $scope.newProposalForm.$valid and $scope.sessionSettings.hub_attributes.id
      $scope.sessionSettings.actions.focus = 'publish'
      Focus 'publish'
    else if $scope.sessionSettings.hub_attributes.id
      $scope.alertService.setError 'The proposal is not quite right, too short perhaps?', $scope, 'main'

  #    $scope.sessionSettings.actions.newProposal.hub = 'active' if $scope.sessionSettings.actions.newProposal.hub isnt 'complete'
#    focusser.focus()
  #    Focus('vote_hub')
  #    Focus('ui-select-search')
  #    uiSelect.focusser[0].focus()

  $scope.finishProp = ->
#    console.log 'hi from finishProp '
    $scope.sessionSettings.actions.newProposal.hub = 'complete'
    $scope.sessionSettings.actions.focus = 'publish'
    Focus 'publish'

  #    $scope.sessionSettings.actions.focus = 'none'
#    Focus('vote_hub')
#    Focus('ui-select-search')

  $scope.goToGroup = (action) ->
    if $scope.sessionSettings.hub_attributes.id?
#      $location.path('/proposals').search('hub', $scope.sessionSettings.hub_attributes.id).hash('navigationBar')      # Angular empty hash bug
      $scope.sessionSettings.actions.hubFilter = $scope.sessionSettings.hub_attributes.group_name
      $scope.sessionSettings.actions.wizardToGroup = action
]

App.controller 'StartController', StartController
