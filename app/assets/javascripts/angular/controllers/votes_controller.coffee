VoteNewCtrl = ($scope, $location, Vote) ->
  $scope.modal = {content: 'Hello Modal', saved: false};    # part of angular-strap concept

  $scope.addVote = ->
    $scope.newVote.proposal_id = $scope.parent_id
    $scope.newVote.user_id = $scope.currentUser.id
    $scope.addvote_result = null
    $scope.jsonErrors = null
    $scope.addvote_alert = false
    if 1 == 1
      vote = Vote.save($scope.newVote
          #TODO Error handling needs to be refactored into a Service
      ,  (response, status, headers, config) ->
        $scope.alertclass = 'ngalert alert-success'
        $scope.addvote_result = "Your " + vote.comment + " group was created."
        $scope.proposal.$get()
        $scope.modal.saved = true
        $scope.dismiss()

      ,  (response, status, headers, config) ->
        $scope.alertclass = 'ngalert alert-error'

        if(response.status == 406)
          $scope.addvote_result = "You must be logged in"
        else
          $scope.jsonErrors = response.data
      )
    else
      $scope.alertclass = 'ngalert alert-error'
      $scope.addvote_result = "Please select a Location from the provided list"

    $scope.addvote_alert = true

VoteNewCtrl.$inject = ['$scope', '$location', 'Vote']
angularApp.controller 'VoteNewCtrl', VoteNewCtrl


ProposalImroveCtrl = ($scope, $location, Proposal) ->
  $scope.improveProposal = ->
    improvedProposal = {}
    improvedProposal.proposal = {}
    improvedProposal.proposal.votes_attributes = {}
    improvedProposal.proposal.parent_id = $scope.parent_id
    improvedProposal.user_id = $scope.currentUser.id
    improvedProposal.proposal.statement = $scope.improvedProposal.statement
    improvedProposal.proposal.votes_attributes.comment = $scope.improvedProposal.comment
    $scope.jsonErrors = null
    $scope.improveProposal_result = null
    $scope.improveProposal_alert = false
    if 1 == 1
      improvedProposal = Proposal.save(improvedProposal
        #TODO Error handling needs to be refactored into a Service
      ,  (response, status, headers, config) ->
        $scope.alertclass = 'ngalert alert-success'
        $scope.improveProposal_result = "Your " + improvedProposal.statement + " proposal was created."
        $scope.proposal.$get()  #TODO This works, but I'm confused why I can't call my ProposalLoader() service instead
        $scope.dismiss()

      ,  (response, status, headers, config) ->
        $scope.alertclass = 'ngalert alert-error'

        if(response.status == 406)
          $scope.improveProposal_result = "You must be logged in"
        else
          $scope.jsonErrors = response.data
      )
    else
      $scope.alertclass = 'ngalert alert-error'
      $scope.improveProposal_result = "Please select a Location from the provided list"

    $scope.improveProposal_alert = true

ProposalImroveCtrl.$inject = ['$scope', '$location', 'Proposal']
angularApp.controller 'ProposalImroveCtrl', ProposalImroveCtrl