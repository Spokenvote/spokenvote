StartController = [ '$scope', '$location', 'Focus', '$timeout', '$http', ( $scope, $location, Focus, $timeout, $http ) ->
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
#    Focus('comment-text')

  $scope.hubStep = ->
    $scope.sessionSettings.actions.newProposal.comment = 'complete'
    $scope.sessionSettings.actions.newProposal.hub = 'active'
    Focus('vote_hub')
#    Focus('ui-select-search')

  $scope.goToGroup = (action) ->
    if $scope.sessionSettings.hub_attributes.id?
      $location.path('/proposals').search('hub', $scope.sessionSettings.hub_attributes.id).hash('navigationBar')
      $scope.sessionSettings.actions.hubFilter = $scope.sessionSettings.hub_attributes.group_name
      $scope.sessionSettings.actions.wizardToGroup = action

  $scope.disabled = `undefined`

  $scope.enable = ->
    $scope.disabled = false

  $scope.disable = ->
    $scope.disabled = true

  $scope.clear = ->
    $scope.address.selected = `undefined`

  $scope.hubFilter = {}
  $scope.refreshHubs = (hub_filter) ->
    if hub_filter.length > 1
      params =
        hub_filter: hub_filter

      $http.get("/hubs",
        params: params
      ).then (response) ->
        $scope.hubs = response.data
  #      $scope.$log.log response.data


]

App.controller 'StartController', StartController
