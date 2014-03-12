#modalCtrl = [ '$scope', '$modalInstance', '$location', 'AlertService', ( $scope, $modalInstance, $location, AlertService ) ->
GetStartedCtrl = [ '$scope', '$location', '$rootScope', '$modalInstance', 'AlertService', 'Proposal', ( $scope, $location, $rootScope, $modalInstance, AlertService, Proposal ) ->
  AlertService.clearAlerts()
  $scope.newProposal = {}    # Holds forms data for $modal issue that it creates two scopes

  $scope.changeHub = (request) ->
    if request = true and $scope.sessionSettings.actions.changeHub != 'new'
      $scope.sessionSettings.actions.newProposalHub = null
      $scope.sessionSettings.actions.changeHub = !$scope.sessionSettings.actions.changeHub

  $scope.test = "1"

  $scope.goToGroup = (action) ->
    console.log 'action'

    if $scope.sessionSettings.hub_attributes.id?
      $location.path('/proposals').search('hub', $scope.sessionSettings.hub_attributes.id)
      $scope.sessionSettings.actions.hubFilter = $scope.sessionSettings.hub_attributes.group_name
      $scope.sessionSettings.actions.wizardToGroup = action

  $scope.tooltips =
    newHub: "You may change the group to which you are directing
                          this proposal by clicking here."

  #GetStartedCtrl = [ '$scope', '$location', '$rootScope', 'AlertService', 'Proposal', ( $scope, $location, $rootScope, AlertService, Proposal ) ->
  $scope.sessionSettings.hub_attributes.id = null
  $scope.sessionSettings.actions.newProposalHub = null
  $scope.sessionSettings.actions.changeHub = true
  $scope.sessionSettings.actions.wizardToGroup = null


  $scope.saveNewProposal = ->
    if !$scope.sessionSettings.hub_attributes.id?
      $scope.sessionSettings.hub_attributes.group_name = $scope.sessionSettings.actions.searchTerm
    newProposal =
      proposal:
        statement: $scope.newProposal.statement
        votes_attributes:
          comment: $scope.newProposal.comment
        hub_id: $scope.sessionSettings.hub_attributes.id
        hub_attributes: $scope.sessionSettings.hub_attributes

    AlertService.clearAlerts()

    Proposal.save(newProposal
    ,  (response, status, headers, config) ->
      $rootScope.$broadcast 'event:proposalsChanged'
      AlertService.setSuccess 'Your new proposal stating: \"' + response.statement + '\" was created.',$scope
      $location.path('/proposals/' + response.id).search('hub', response.hub_id).search('filter', 'my')
      $modalInstance.close(response)
      $scope.sessionSettings.actions.offcanvas = false
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your new proposal was not saved.', $scope
      AlertService.setJson response.data
    )

]

# Injects
#modalCtrl.$inject = [ '$scope', '$location', 'SessionSettings', 'AlertService', 'dialog' ]
#GetStartedCtrl.$inject = [ '$scope', '$location', 'SessionSettings' ]

# Register
#App.controller 'modalCtrl', modalCtrl
App.controller 'GetStartedCtrl', GetStartedCtrl
