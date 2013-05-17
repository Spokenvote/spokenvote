VoteNewCtrl = ($scope, $location, AlertService, Vote) ->
  if $scope.current_user_support == 'related_proposal'
    AlertService.setCtlResult 'We found support from you on another proposal. If you continue, your previous support will be moved here.'

  $scope.supportProposal = ->
    $scope.newSupport.proposal_id = $scope.clicked_proposal_id
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

VoteNewCtrl.$inject = ['$scope', '$location', 'AlertService', 'Vote' ]
angularApp.controller 'VoteNewCtrl', VoteNewCtrl


ProposalImroveCtrl = ($scope, $location, AlertService, Proposal) ->
  if $scope.current_user_support == 'related_proposal'
    AlertService.setCtlResult 'We found support from you on another proposal. If you create a new, improved propsal your previous support will be moved here.'

  $scope.improveProposal = ->
    improvedProposal = {}       #TODO: Does it really take 7 lines to build this object? Would love to see it done in fewer lines.
    improvedProposal.proposal = {}
    improvedProposal.proposal.votes_attributes = {}
    improvedProposal.proposal.parent_id = $scope.clicked_proposal_id
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

ProposalImroveCtrl.$inject = ['$scope', '$location', 'AlertService', 'Proposal']
angularApp.controller 'ProposalImroveCtrl', ProposalImroveCtrl