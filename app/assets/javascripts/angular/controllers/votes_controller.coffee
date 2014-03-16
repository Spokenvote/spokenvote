SupportCtrl = [ '$scope', '$location', '$rootScope', '$modalInstance', 'AlertService', 'Vote', ( $scope, $location, $rootScope, $modalInstance, AlertService, Vote ) ->
  AlertService.clearAlerts()
  if $scope.current_user_support == 'related_proposal'
    AlertService.setCtlResult 'We found support from you on another proposal. If you continue, your previous support will be moved here.', $scope, 'modal'

  $scope.saveSupport = ->
    $scope.newSupport.proposal_id = $scope.clicked_proposal.id
    AlertService.clearAlerts()

    vote = Vote.save($scope.newSupport
    ,  (response, status, headers, config) ->
      $rootScope.$broadcast 'event:votesChanged'
      AlertService.setSuccess 'Your vote was created with the comment: \"' + response.comment + '\"', $scope, 'main'
      $modalInstance.close(response)
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your vote to support this proposal was not counted.', $scope, 'modal'
      AlertService.setJson response.data
    )
]

ImroveCtrl = [ '$scope', '$location', '$rootScope', '$modalInstance', 'AlertService', 'Proposal', ($scope, $location, $rootScope, $modalInstance, AlertService, Proposal) ->
  AlertService.clearAlerts()

  if $scope.current_user_support == 'related_proposal'
    AlertService.setCtlResult 'We found support from you on another proposal. If you create a new, improved propsal your previous support will be moved here.', $scope, 'modal'

  $scope.improvedProposal =
    statement: $scope.clicked_proposal.statement

  $scope.saveImprovement = ->
    improvedProposal =
      proposal:
        parent_id: $scope.clicked_proposal.id
        statement: $scope.improvedProposal.statement
        votes_attributes:
          comment: $scope.improvedProposal.comment

    AlertService.clearAlerts()

    improvedProposal = Proposal.save(improvedProposal
    ,  (response, status, headers, config) ->
      $location.path('/proposals/' + response.id)
      AlertService.setSuccess 'Your improved proposal stating: \"' + response.statement + '\" was created.', $scope, 'main'
      $modalInstance.close(response)
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your improved proposal was not saved.', $scope, 'modal'
      AlertService.setJson response.data
    )
]

EditProposalCtrl = [ '$scope', '$location', '$rootScope', '$modalInstance', 'AlertService', 'Proposal', ($scope, $location, $rootScope, $modalInstance, AlertService, Proposal) ->
  $scope.clicked_proposal = $scope.clicked_proposal

  if $scope.clicked_proposal.votes.length > 1
    AlertService.setCtlResult "We found support from other users on your proposal. You can no longer edit your proposal, but you can Improve it to get a similar result.", $scope

  $scope.editProposal =
    id: $scope.clicked_proposal.id
    proposal:
      statement: $scope.clicked_proposal.statement
      votes_attributes:
        comment: $scope.clicked_proposal.votes[0].comment
        id: $scope.clicked_proposal.votes[0].id

  $scope.saveEdit = ->
    AlertService.clearAlerts()

    Proposal.update($scope.editProposal
    ,  (response, status, headers, config) ->
      $rootScope.$broadcast 'event:votesChanged'
      AlertService.setSuccess 'Your proposal stating: \"' + response.statement + '\" has been saved.', $scope
      $modalInstance.close(response)
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your improved proposal was not saved.', $scope
      AlertService.setJson response.data
    )
]

DeleteProposalCtrl = [ '$scope', '$location', '$rootScope', '$modalInstance', 'AlertService', 'Proposal', ($scope, $location, $rootScope, $modalInstance, AlertService, Proposal) ->
  $scope.clicked_proposal = $scope.clicked_proposal

  if $scope.clicked_proposal.votes.length > 1
    AlertService.setCtlResult "We found support from other users on your proposal. You can no longer delete your proposal, but you can Improve it if you'd like to make a different proposal.", $scope

  $scope.deleteProposal = ->
    AlertService.clearAlerts()

    Proposal.delete($scope.clicked_proposal
    ,  (response, status, headers, config) ->
      AlertService.setSuccess 'Your proposal stating: \"' + $scope.clicked_proposal.statement + '\" was deleted.', $scope
      $location.path('/proposals').search('hub', $scope.clicked_proposal.hub_id)
      $modalInstance.close(response)
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your  proposal could not be deleted.', $scope
      AlertService.setJson response.data
    )
]

NewProposalCtrl = [ '$scope', '$location', '$rootScope', '$modalInstance', 'AlertService', 'Proposal', ($scope, $location, $rootScope, $modalInstance, AlertService, Proposal) ->
  AlertService.clearAlerts()
  $scope.newProposal = {}    # Holds forms data for $modal issue that it creates two scopes

  $scope.changeHub = (request) ->
    if request = true and $scope.sessionSettings.actions.changeHub != 'new'
      $scope.sessionSettings.actions.changeHub = !$scope.sessionSettings.actions.changeHub

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
      AlertService.setSuccess 'Your new proposal stating: \"' + response.statement + '\" was created.', $scope, 'main'
      $location.path('/proposals/' + response.id).search('hub', response.hub_id).search('filter', 'my')
      $modalInstance.close(response)
      $scope.sessionSettings.actions.offcanvas = false
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your new proposal was not saved.', $scope
      AlertService.setJson response.data
    )

#  $scope.tooltips =
#    newHub: "You may change the group to which you are directing
#                  this proposal by clicking here."
]

# Injects
#SupportCtrl.$inject = [ '$scope', '$location', '$rootScope', 'AlertService', 'Vote', '$modal' ]
#ImroveCtrl.$inject = [ '$scope', '$location', '$rootScope', '$modalInstance', 'AlertService', 'Proposal' ]
#EditProposalCtrl.$inject = [ '$scope', '$location', '$rootScope', '$modalInstance', 'AlertService', 'Proposal' ]
#DeleteProposalCtrl.$inject = [ '$scope', '$location', '$rootScope', '$modalInstance', 'AlertService', 'Proposal' ]
#NewProposalCtrl.$inject = [ '$scope', '$location', '$rootScope', '$modalInstance', 'AlertService', 'Proposal' ]

# Register
App.controller 'SupportCtrl', SupportCtrl
App.controller 'ImroveCtrl', ImroveCtrl
App.controller 'EditProposalCtrl', EditProposalCtrl
App.controller 'DeleteProposalCtrl', DeleteProposalCtrl
App.controller 'NewProposalCtrl', NewProposalCtrl