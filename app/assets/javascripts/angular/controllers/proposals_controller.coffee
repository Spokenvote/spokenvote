ProposalListCtrl = ($scope, $routeParams, $location, proposals, current_user, HubSelected, SpokenvoteCookies) ->
  $scope.proposals = proposals
  $scope.currentUser = current_user
  $scope.hubSelection = HubSelected
  $scope.filterSelection = $routeParams.filter
  $scope.spokenvoteSession = SpokenvoteCookies

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

ProposalListCtrl.$inject = ['$scope', '$routeParams', '$location', 'proposals', 'current_user', 'HubSelected', 'SpokenvoteCookies']
angularApp.controller 'ProposalListCtrl', ProposalListCtrl

ProposalViewCtrl = ($scope, $location, AlertService, proposal, current_user, SessionSettings, $modal, RelatedVoteInTreeLoader) ->
  $scope.proposal = proposal
  $scope.currentUser = current_user
  $scope.defaultGravatar = SessionSettings.defaultGravatar

  $scope.support = (clicked_proposal_id) ->
    $scope.clicked_proposal_id = clicked_proposal_id
    $scope.current_user_support = ''
    RelatedVoteInTreeLoader($scope.clicked_proposal_id).then (relatedSupport) ->
      if relatedSupport.id?
        if relatedSupport.proposal.id == $scope.clicked_proposal_id
          $scope.current_user_support = 'this_proposal'
        else
          $scope.current_user_support = 'related_proposal'
      if $scope.current_user_support == 'this_proposal'
        AlertService.setCtlResult 'Good news, it looks as if you have already supported this proposal. Further editing is not supported at this time.'
      else
        $modal
          template: '/assets/proposals/_vote_modal.html.haml'
          show: true
          backdrop: 'static'
          scope: $scope

  $scope.improve = (clicked_proposal_id) ->
    $scope.clicked_proposal_id = clicked_proposal_id
    $scope.current_user_support = ''
    RelatedVoteInTreeLoader($scope.clicked_proposal_id).then (relatedSupport) ->
      if relatedSupport.id?
        $scope.current_user_support = 'related_proposal'
      $modal
        template: '/assets/proposals/_improve_proposal_modal.html.haml'
        show: true
        backdrop: 'static'
        scope: $scope

ProposalViewCtrl.$inject = ['$scope', '$location', 'AlertService', 'proposal', 'current_user', 'SessionSettings', '$modal', 'RelatedVoteInTreeLoader']
angularApp.controller 'ProposalViewCtrl', ProposalViewCtrl




