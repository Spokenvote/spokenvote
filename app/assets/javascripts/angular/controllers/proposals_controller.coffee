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

ProposalViewCtrl = ($scope, $location, proposal, current_user, SessionSettings) ->
  $scope.proposal = proposal
  $scope.currentUser = current_user

  $scope.fakeFacebookUser = '100002611078431'
  $scope.defaultGravatar = SessionSettings.defaultGravatar

ProposalViewCtrl.$inject = ['$scope', '$location', 'proposal', 'current_user', 'SessionSettings']
angularApp.controller 'ProposalViewCtrl', ProposalViewCtrl