SupportCtrl = ($scope, $location, $rootScope, AlertService, Vote) ->
  if $scope.current_user_support == 'related_proposal'
    AlertService.setCtlResult 'We found support from you on another proposal. If you continue, your previous support will be moved here.', $scope

  $scope.saveSupport = ->
    $scope.newSupport.proposal_id = $scope.clicked_proposal_id
    $scope.newSupport.user_id = $scope.currentUser.id
    AlertService.clearAlerts()

    vote = Vote.save($scope.newSupport
    ,  (response, status, headers, config) ->
      $rootScope.$broadcast 'event:votesChanged'
      AlertService.setSuccess 'Your vote was created with the comment: \"' + response.comment + '\"', $scope
      $scope.dismiss()
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your vote to support this proposal was not counted.', $scope
      AlertService.setJson response.data
    )

ImroveCtrl = ($scope, $location, $rootScope, AlertService, Proposal) ->
  if $scope.current_user_support == 'related_proposal'
    AlertService.setCtlResult 'We found support from you on another proposal. If you create a new, improved propsal your previous support will be moved here.', $scope

  $scope.improvedProposal = {}
  $scope.improvedProposal.statement = $scope.proposal.statement

  $scope.saveImprovement = ->
    improvedProposal = {}       #TODO: Refactor to a complex object.
    improvedProposal.proposal = {}
    improvedProposal.proposal.votes_attributes = {}
    improvedProposal.proposal.parent_id = $scope.clicked_proposal_id
    improvedProposal.user_id = $scope.currentUser.id
    improvedProposal.proposal.statement = $scope.improvedProposal.statement
    improvedProposal.proposal.votes_attributes.comment = $scope.improvedProposal.comment
    AlertService.clearAlerts()

    improvedProposal = Proposal.save(improvedProposal
    ,  (response, status, headers, config) ->
      $rootScope.$broadcast 'event:votesChanged'
      AlertService.setSuccess 'Your improved proposal stating: \"' + response.statement + '\" was created.', $scope
      $scope.dismiss()
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your improved proposal was not saved.', $scope
      AlertService.setJson response.data
    )

EditProposalCtrl = ($scope, $location, $rootScope, AlertService, Proposal) ->
  if $scope.clicked_proposal.votes.length > 1
    AlertService.setCtlResult "We found support from other users on your proposal. You can no longer edit your proposal, but you can Improve it to get a similar result.", $scope

  $scope.editProposal =
    proposal:
      id: $scope.clicked_proposal.id
      statement: $scope.clicked_proposal.statement
      votes_attributes: [
        comment: $scope.clicked_proposal.votes[0].comment
        id: $scope.clicked_proposal.votes[0].id
      ]

  console.log $scope.editProposal.proposal
  console.log $scope.editProposal.proposal.votes_attributes[0].comment

  $scope.saveEdit = ->
    AlertService.clearAlerts()

    Proposal.update($scope.editProposal
    ,  (response, status, headers, config) ->
      AlertService.setSuccess 'Your proposal stating: \"' + response.statement + '\" has been saved.', $scope
      $scope.dismiss()
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your improved proposal was not saved.', $scope
      AlertService.setJson response.data
    )

DeleteProposalCtrl = ($scope, $location, $rootScope, dialog, AlertService, Proposal, parentScope) ->
  $scope.sessionSettings = parentScope.sessionSettings
  $scope.currentUser = parentScope.currentUser
  $scope.clicked_proposal = parentScope.clicked_proposal

  if parentScope.clicked_proposal.votes.length > 1
    AlertService.setCtlResult "We found support from other users on your proposal. You can no longer delete your proposal, but you can Improve it if you'd like to make a different proposal.", $scope

  $scope.deleteProposal = ->
    AlertService.clearAlerts()

    Proposal.delete($scope.clicked_proposal
    ,  (response, status, headers, config) ->
      AlertService.setSuccess 'Your proposal stating: \"' + $scope.clicked_proposal.statement + '\" was deleted.', parentScope
      $location.path('/proposals').search('hub', parentScope.clicked_proposal.hub_id)
      dialog.close(response)
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your  proposal could not be deleted.', $scope
      AlertService.setJson response.data
    )

  $scope.close = (result) ->
    dialog.close(result)

NewProposalCtrl = ($scope, parentScope, $location, $rootScope, dialog, AlertService, Proposal) ->
  $scope.sessionSettings = parentScope.sessionSettings
  $scope.currentUser = parentScope.currentUser

  $scope.saveNewProposal = ->
    if !$scope.sessionSettings.hub_attributes.id?
      $scope.sessionSettings.hub_attributes.group_name = $scope.sessionSettings.actions.searchTerm
    newProposal =
      proposal:
        hub_id: $scope.sessionSettings.hub_attributes.id
        statement: $scope.newProposal.statement
        votes_attributes: [comment: $scope.newProposal.comment]
        hub_attributes: $scope.sessionSettings.hub_attributes

    console.log newProposal
    console.log $scope.sessionSettings.hub_attributes.group_name

    AlertService.clearAlerts()

    Proposal.save(newProposal
    ,  (response, status, headers, config) ->
      $rootScope.$broadcast 'event:proposalsChanged'
      AlertService.setSuccess 'Your new proposal stating: \"' + response.statement + '\" was created.', parentScope
      $location.path('/proposals/' + response.id)
      dialog.close(response)
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your new proposal was not saved.', $scope
      AlertService.setJson response.data
    )

  $scope.close = (result) ->
    dialog.close(result)

# Injects
SupportCtrl.$inject = [ '$scope', '$location', '$rootScope', 'AlertService', 'Vote' ]
ImroveCtrl.$inject = [ '$scope', '$location', '$rootScope', 'AlertService', 'Proposal' ]
EditProposalCtrl.$inject = [ '$scope', '$location', '$rootScope', 'AlertService', 'Proposal' ]
DeleteProposalCtrl.$inject = [ '$scope', '$location', '$rootScope', 'dialog', 'AlertService', 'Proposal', 'parentScope' ]
NewProposalCtrl.$inject = [ '$scope', 'parentScope', '$location', '$rootScope', 'dialog', 'AlertService', 'Proposal' ]

# Register
App.controller 'SupportCtrl', SupportCtrl
App.controller 'ImroveCtrl', ImroveCtrl
App.controller 'EditProposalCtrl', EditProposalCtrl
App.controller 'DeleteProposalCtrl', DeleteProposalCtrl
App.controller 'NewProposalCtrl', NewProposalCtrl