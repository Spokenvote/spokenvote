SupportCtrl = [ '$scope', '$location', '$rootScope', '$modalInstance', 'Vote', ( $scope, $location, $rootScope, $modalInstance, Vote ) ->
  $scope.alertService.clearAlerts()
  if $rootScope.sessionSettings.newSupport.related?
    $scope.alertService.setCtlResult 'We found support from you on another proposal. If you continue, your previous support will be moved here.', $scope, 'modal'

  $scope.saveSupport = ->
    $scope.alertService.clearAlerts()
    $rootScope.sessionSettings.newSupport.save.proposal_id = $rootScope.sessionSettings.newSupport.target.id

#    vote = Vote.save($scope.sessionSettings.newSupport.save
#    ,  (response, status, headers, config) ->
#      $rootScope.$broadcast 'event:votesChanged'
#      $scope.alertService.setSuccess 'Your vote was created with the comment: \"' + response.comment + '\"', $scope, 'main'
#      $modalInstance.close(response)
#      $location.path('/proposals/' + response.proposal_id).hash('prop' + $rootScope.sessionSettings.newSupport.save.proposal_id)
#    ,  (response, status, headers, config) ->
#      $scope.alertService.setCtlResult 'Sorry, your vote to support this proposal was not counted.', $scope, 'modal'
#      $scope.alertService.setJson response.data
#    )

    vote = Vote.save(
      ($scope.sessionSettings.newSupport.save
      ), ((response, status, headers, config) ->
        $rootScope.$broadcast "event:votesChanged"
        $scope.alertService.setSuccess "Your vote was created with the comment: \"" + response.comment + "\"", $scope, "main"
        $modalInstance.close response
        $location.path("/proposals/" + response.proposal_id).hash "prop" + $rootScope.sessionSettings.newSupport.save.proposal_id
      ), (response, status, headers, config) ->
        $scope.alertService.setCtlResult "Sorry, your vote to support this proposal was not counted.", $scope, "modal"
        $scope.alertService.setJson response.data
    )
]

ImproveCtrl = [ '$scope', '$location', '$rootScope', '$modalInstance', 'Proposal', ($scope, $location, $rootScope, $modalInstance, Proposal) ->
  $scope.alertService.clearAlerts()

  if $scope.current_user_support == 'related_proposal'
    $scope.alertService.setCtlResult 'We found support from you on another proposal. If you create a new, improved propsal your previous support will be moved here.', $scope, 'modal'

  $scope.improvedProposal =
    statement: $scope.clicked_proposal.statement

  $scope.saveImprovement = ->
    improvedProposal =
      proposal:
        parent_id: $scope.clicked_proposal.id
        statement: $scope.improvedProposal.statement
        votes_attributes:
          comment: $scope.improvedProposal.comment

    $scope.alertService.clearAlerts()

    improvedProposal = Proposal.save(
      (improvedProposal
      ),  ((response, status, headers, config) ->
        $location.path('/proposals/' + response.id)
        $scope.alertService.setSuccess 'Your improved proposal stating: \"' + response.statement + '\" was created.', $scope, 'main'
        $modalInstance.close(response)
      ),  (response, status, headers, config) ->
        $scope.alertService.setCtlResult 'Sorry, your improved proposal was not saved.', $scope, 'modal'
        $scope.alertService.setJson response.data
    )
]

EditProposalCtrl = [ '$scope', '$location', '$rootScope', '$modalInstance', 'Proposal', ($scope, $location, $rootScope, $modalInstance, Proposal) ->
  $scope.clicked_proposal = $scope.clicked_proposal

  if $scope.clicked_proposal.votes.length > 1
    $scope.alertService.setCtlResult "We found support from other users on your proposal. You can no longer edit your proposal, but you can Improve it to get a similar result.", $scope

  $scope.editProposal =
    id: $scope.clicked_proposal.id
    proposal:
      statement: $scope.clicked_proposal.statement
      votes_attributes:
        comment: $scope.clicked_proposal.votes[0].comment
        id: $scope.clicked_proposal.votes[0].id

  $scope.saveEdit = ->
    $scope.alertService.clearAlerts()

    Proposal.update(
      ($scope.editProposal
      ), ((response, status, headers, config) ->
        $rootScope.$broadcast 'event:votesChanged'
        $scope.alertService.setSuccess 'Your proposal stating: \"' + response.statement + '\" has been saved.', $scope
        $modalInstance.close(response)
      ), (response, status, headers, config) ->
        $scope.alertService.setCtlResult 'Sorry, your improved proposal was not saved.', $scope
        $scope.alertService.setJson response.data
    )
]

DeleteProposalCtrl = [ '$scope', '$location', '$rootScope', '$modalInstance', 'Proposal', ($scope, $location, $rootScope, $modalInstance, Proposal) ->
  $scope.clicked_proposal = $scope.clicked_proposal

  if $scope.clicked_proposal.votes.length > 1
    $scope.alertService.setCtlResult "We found support from other users on your proposal. You can no longer delete your proposal, but you can Improve it if you'd like to make a different proposal.", $scope

  $scope.deleteProposal = ->
    $scope.alertService.clearAlerts()

    Proposal.delete(
      ($scope.clicked_proposal
      ), ((response, status, headers, config) ->
        $scope.alertService.setSuccess 'Your proposal stating: \"' + $scope.clicked_proposal.statement + '\" was deleted.', $scope
        $location.path('/proposals').search('hub', $scope.clicked_proposal.hub_id)
        $modalInstance.close(response)
      ), (response, status, headers, config) ->
        $scope.alertService.setCtlResult 'Sorry, your proposal could not be deleted.', $scope
        $scope.alertService.setJson response.data
    )
]

NewProposalCtrl = [ '$scope', '$modalInstance', ($scope, $modalInstance ) ->
  $scope.modalInstance = $modalInstance
]

# Register
App.controller 'SupportCtrl', SupportCtrl
App.controller 'ImproveCtrl', ImproveCtrl
App.controller 'EditProposalCtrl', EditProposalCtrl
App.controller 'DeleteProposalCtrl', DeleteProposalCtrl
App.controller 'NewProposalCtrl', NewProposalCtrl