VoteNewCtrl = ($scope, $location, Vote, AlertService) ->

  $scope.supportProposal = ->
    $scope.newSupport.proposal_id = $scope.parent_id
    $scope.newSupport.user_id = $scope.currentUser.id
    AlertService.clearAlerts()

    vote = Vote.save($scope.newSupport
    ,  (response, status, headers, config) ->
      $scope.proposal.$get()
      AlertService.setSuccess 'Your vote was created with the comment: \"' + response.comment + '\"'
      $scope.dismiss()
    ,  (response, status, headers, config) ->
#      AlertService.setCallingScope $scope     # feature for future use
      AlertService.setCtlResult 'Sorry, your vote to support this proposal was not counted.'
      AlertService.setJson response.data
    )

VoteNewCtrl.$inject = ['$scope', '$location', 'Vote', 'AlertService']
angularApp.controller 'VoteNewCtrl', VoteNewCtrl


ProposalImroveCtrl = ($scope, $location, Proposal, AlertService) ->

  $scope.improveProposal = ->
    improvedProposal = {}       #TODO: Does it really take 7 lines to build this object? Would love to see it done in fewer lines.
    improvedProposal.proposal = {}
    improvedProposal.proposal.votes_attributes = {}
    improvedProposal.proposal.parent_id = $scope.parent_id
    improvedProposal.user_id = $scope.currentUser.id
    improvedProposal.proposal.statement = $scope.improvedProposal.statement
    improvedProposal.proposal.votes_attributes.comment = $scope.improvedProposal.comment
    AlertService.clearAlerts()

    improvedProposal = Proposal.save(improvedProposal
    ,  (response, status, headers, config) ->
      $scope.proposal.$get()
      AlertService.setSuccess 'Your improved proposal stating: \"' + response.statement + '\" was created.'
      $scope.dismiss()
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your improved proposal was not saved.'
      AlertService.setJson response.data
    )

ProposalImroveCtrl.$inject = ['$scope', '$location', 'Proposal', 'AlertService']
angularApp.controller 'ProposalImroveCtrl', ProposalImroveCtrl