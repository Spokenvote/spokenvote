ProposalsCtrl = ($scope, $routeParams, $location, Proposal, HubSelected, HubProposals, Test) ->
  $scope.searchSelection = HubSelected         #TODO Remove
  $scope.filterSelection = $routeParams.filter
  angular.extend($scope.proposals, HubProposals)
  # or have tried: $scope.proposals = HubProposals
  $scope.proposals = Proposal.query
    filter: $scope.filterSelection
  $scope.ptest = Test

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

ProposalsCtrl.$inject = ['$scope', '$routeParams', '$location', 'Proposal', 'HubSelected', 'HubProposals', 'Test']
angularApp.controller 'ProposalsCtrl', ProposalsCtrl