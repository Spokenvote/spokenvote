ProposalListCtrl = ($scope, $routeParams, $location, proposals, HubSelected, SpokenvoteCookies) ->
  $scope.hubSelection = HubSelected
  $scope.filterSelection = $routeParams.filter
  $scope.proposals = proposals
  $scope.spokenvoteSession = SpokenvoteCookies
  console.log($scope.spokenvoteSession.sessionCookie)

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

ProposalListCtrl.$inject = ['$scope', '$routeParams', '$location', 'proposals', 'HubSelected', 'SpokenvoteCookies']
angularApp.controller 'ProposalListCtrl', ProposalListCtrl

ProposalViewCtrl = ($scope, $location, proposal) ->
  $scope.proposal = proposal

ProposalViewCtrl.$inject = ['$scope', '$location', 'proposal']
angularApp.controller 'ProposalViewCtrl', ProposalViewCtrl