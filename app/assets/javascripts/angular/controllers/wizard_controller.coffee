GetStartedCtrl = [ '$scope', '$location', '$modalInstance', ( $scope, $rootScope, $modalInstance ) ->
  $scope.alertService.clearAlerts()
  $scope.modalInstance = $modalInstance
  $scope.sessionSettings.hub_attributes.id = null
  $scope.sessionSettings.actions.newProposalHub = null
  $scope.sessionSettings.actions.changeHub = true
  $scope.sessionSettings.actions.wizardToGroup = null

  $scope.goToGroup = (action) ->
    if $scope.sessionSettings.hub_attributes.id?
      $location.path('/proposals').search('hub', $scope.sessionSettings.hub_attributes.id)
      $scope.sessionSettings.actions.hubFilter = $scope.sessionSettings.hub_attributes.group_name
      $scope.sessionSettings.actions.wizardToGroup = action

#  $scope.changeHub = (request) ->                   # TODO Delete this code
#    if request = true and $scope.sessionSettings.actions.changeHub != 'new'
#      $scope.sessionSettings.actions.newProposalHub = null
#      $scope.sessionSettings.actions.changeHub = !$scope.sessionSettings.actions.changeHub

#  $scope.saveNewProposal = ->
#    $scope.votingService.saveNewProposal $modalInstance


#  $scope.newProposal = {}    # Holds forms data for $modal issue that it creates two scopes

#  $scope.saveNewProposal = ->
#    if !$scope.sessionSettings.hub_attributes.id?
#      $scope.sessionSettings.hub_attributes.group_name = $scope.sessionSettings.actions.searchTerm
#    newProposal =
#      proposal:
#        statement: $scope.sessionSettings.newProposal.statement
#        votes_attributes:
#          comment: $scope.sessionSettings.newProposal.comment
#        hub_id: $scope.sessionSettings.hub_attributes.id
#        hub_attributes: $scope.sessionSettings.hub_attributes
##    newProposal =
##      proposal:
##        statement: $scope.newProposal.statement
##        votes_attributes:
##          comment: $scope.newProposal.comment
##        hub_id: $scope.sessionSettings.hub_attributes.id
##        hub_attributes: $scope.sessionSettings.hub_attributes
#
#    AlertService.clearAlerts()
#
#    Proposal.save(newProposal
#    ,  (response, status, headers, config) ->
#      $rootScope.$broadcast 'event:proposalsChanged'
#      AlertService.setSuccess 'Your new proposal stating: \"' + response.statement + '\" was created.', $scope, 'main'
#      $location.path('/proposals/' + response.id).search('hub', response.hub_id).search('filter', 'my')
#      $modalInstance.close(response)
#      $scope.sessionSettings.actions.offcanvas = false
#    ,  (response, status, headers, config) ->
#      AlertService.setCtlResult 'Sorry, your new proposal was not saved.', $scope, 'modal'
#      AlertService.setJson response.data
#    )

]

App.controller 'GetStartedCtrl', GetStartedCtrl
