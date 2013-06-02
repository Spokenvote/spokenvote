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
      $rootScope.$broadcast 'event:votesChanged'
      AlertService.setSuccess 'Your improved proposal stating: \"' + response.statement + '\" was created.', $scope
      $scope.dismiss()
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your improved proposal was not saved.', $scope
      AlertService.setJson response.data
    )

NewProposalCtrl = ($scope, $location, $rootScope, AlertService, Proposal) ->

  $scope.saveNewProposal = ->
    newProposal = {}
    newProposal.proposal = {}
    newProposal.proposal.votes_attributes = {}
    newProposal.proposal.parent_id = $scope.clicked_proposal_id
    newProposal.user_id = $scope.currentUser.id
    newProposal.proposal.statement = $scope.newProposal.statement
    newProposal.proposal.votes_attributes.comment = $scope.newProposal.comment
    AlertService.clearAlerts()

    newProposal = Proposal.save(newProposal
    ,  (response, status, headers, config) ->
#      $rootScope.$broadcast 'event:votesChanged'
      AlertService.setSuccess 'Your new proposal stating: \"' + response.statement + '\" was created.', $scope
      $scope.dismiss()
    ,  (response, status, headers, config) ->
      AlertService.setCtlResult 'Sorry, your new proposal was not saved.', $scope
      AlertService.setJson response.data
    )

# Injects
SupportCtrl.$inject = ['$scope', '$location', '$rootScope', 'AlertService', 'Vote' ]
ImroveCtrl.$inject = ['$scope', '$location', '$rootScope', 'AlertService', 'Proposal']
NewProposalCtrl.$inject = ['$scope', '$location', '$rootScope', 'AlertService', 'Proposal']

# Register
App.controller 'SupportCtrl', SupportCtrl
App.controller 'ImroveCtrl', ImroveCtrl
App.controller 'NewProposalCtrl', NewProposalCtrl