#StartController = [ '$scope', '$location', 'Focus', '$timeout', '$route', 'proposal', ( $scope, $location, Focus, $timeout, $route, proposal ) ->
StartController = [ '$scope', '$location', 'Focus', '$timeout', '$route', ( $scope, $location, Focus, $timeout, $route ) ->
#  console.log 'StartController restarting'
#  $scope.proposal = proposal
  $scope.alertService.clearAlerts()

#  $scope.sessionSettings.actions.hubShow = false  unless $route.current.params.hub or $scope.sessionSettings.actions.newProposal.started
  $scope.sessionSettings.actions.hubShow = false  unless $scope.sessionSettings.routeParams.hub or $scope.sessionSettings.actions.newProposal.started
  $scope.sessionSettings.actions.newProposal.started = true
  $scope.sessionSettings.actions.hubPlaceholder = 'Who should see your proposal? ...'

#  uiSelect = angular.element 'ui-select-wrapper'
#  console.log 'uiSelect: ', uiSelect.focusser[0]

  #  $scope.sessionSettings.actions.newProposal.hub = 'waiting'  unless $scope.sessionSettings.hub_attributes.id
  #  $scope.sessionSettings.hub_attributes.id = null
#  $scope.sessionSettings.actions.newProposalHub = null
#  console.log '$scope.sessionSettings.actions.newProposal: ', $scope.sessionSettings.actions.newProposal
  #  $scope.sessionSettings.actions.changeHub = true
#  $scope.sessionSettings.actions.wizardToGroup = null

#  focusser = angular.element "<input class='ui-select-focusser ui-select-offscreen' type='text' aria-haspopup='true' role='button' />"
#  console.log 'focusser focus: ', focusser.focus()

  if $scope.sessionSettings.newProposal.statement? and $scope.sessionSettings.hub_attributes?
    $scope.sessionSettings.actions.focus = 'publish'
    Focus '#publish'
  else
    Focus '#proposal_statement'

  $scope.commentStep = ->
    $scope.sessionSettings.actions.newProposal.comment = 'active'
#    element = angular.element '#vote_comment'
#    element = angular.element '.comment-text'

#    $timeout -> element.focus()
#      element = document.getElementById 'vote_comment'
#      element = document.querySelector '.comment-text'
#      element.focus()
    Focus '#vote_comment'

  $scope.hubStep = ->
    $scope.sessionSettings.actions.newProposal.comment = 'complete'
    $scope.sessionSettings.actions.focus = 'hub'
    #    $scope.sessionSettings.actions.newProposal.hub = 'active'  unless $scope.sessionSettings.hub_attributes.id
    if $scope.newProposalForm.$valid and $scope.sessionSettings.hub_attributes.id
      $scope.sessionSettings.actions.focus = 'publish'
      Focus '#publish'
    else if $scope.sessionSettings.hub_attributes.id
      $scope.alertService.setError 'The proposal is not quite right, too short perhaps?', $scope, 'main'

    console.log 'hubstep: '

#    Focus '.ui-select-focusser'

    $timeout ->
      element = angular.element '.ui-select-focusser'
      element.focus()  if element

#    $timeout ->
#      Focus 'input.ui-select-focusser'
#    , 2000
#      selectElementW = angular.element 'ui-select-wrapper'
#      console.log 'selectElementW: ', selectElementW
#      uiSelectW = angular.element 'uiSelect'
#      console.log 'uiSelectW: ', uiSelectW.focusser


#      selectElement = angular.element '.ui-select-container'
#      uiSelectCtl = selectElement.controller('uiSelect')
#      console.log 'uiSelectCtl.focusser: ', uiSelectCtl.focusser
#      uiSelectCtl.focusser[0].focus()
#      uiSelectCtl.focusser.focus()
#      uiSelectCtl.open = true
#      uiSelectCtl.activate(false, true)

  $scope.finishProp = ->
    $scope.sessionSettings.actions.newProposal.hub = 'complete'
    $scope.sessionSettings.actions.focus = 'publish'
    Focus '#publish'

  #    $scope.sessionSettings.actions.newProposal.hub = 'active' if $scope.sessionSettings.actions.newProposal.hub isnt 'complete'
#    focusser.focus()
  #    Focus('vote_hub')
  #    Focus('ui-select-search')
  #    uiSelect.focusser[0].focus()

  #    $scope.sessionSettings.actions.focus = 'none'
#    Focus('vote_hub')
#    Focus('ui-select-search')

]

App.controller 'StartController', StartController
