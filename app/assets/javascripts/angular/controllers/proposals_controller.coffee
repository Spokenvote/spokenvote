ProposalListCtrl = ($scope, $routeParams, $location, proposals, current_user, HubSelected, SpokenvoteCookies) ->
  $scope.hubSelection = HubSelected
  $scope.filterSelection = $routeParams.filter
  $scope.proposals = proposals
  $scope.currentUser = current_user
  $scope.spokenvoteSession = SpokenvoteCookies

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

ProposalListCtrl.$inject = ['$scope', '$routeParams', '$location', 'proposals', 'current_user', 'HubSelected', 'SpokenvoteCookies']
angularApp.controller 'ProposalListCtrl', ProposalListCtrl

ProposalViewCtrl = ($scope, $location, proposal, current_user, SessionSettings, related_proposals, RelatedProposals) ->
  $scope.proposal = proposal
  $scope.currentUser = current_user
  $scope.relatedProposals = related_proposals

  $scope.fakeFacebookUser = '100002611078431'
  $scope.defaultGravatar = SessionSettings.defaultGravatar

  $scope.sortedRelatedProposals = (related_sort_by) ->
    $scope.relatedProposals = RelatedProposals.get({id:related_proposals.id,related_sort_by:related_sort_by})

ProposalViewCtrl.$inject = ['$scope', '$location', 'proposal', 'current_user', 'SessionSettings', 'related_proposals','RelatedProposals']
angularApp.controller 'ProposalViewCtrl', ProposalViewCtrl
