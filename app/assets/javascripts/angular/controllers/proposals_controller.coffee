ProposalsCtrl = ($scope, $routeParams, $location, Proposal, HubSelected, HubProposals) ->
  $scope.filterSelection = $routeParams.filter
  $scope.searchSelection = HubSelected
  $scope.proposals = HubProposals
  $scope.hubProposals = Proposal.query
    filter: $scope.filterSelection

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

  submitHubSearch = ->
    angular.copy($scope.hubProposals, HubProposals)
    console.log(HubProposals)

  $scope.$watch('hubProposals', submitHubSearch, true)

ProposalsCtrl.$inject = ['$scope', '$routeParams', '$location', 'Proposal', 'HubSelected', 'HubProposals']
angularApp.controller 'ProposalsCtrl', ProposalsCtrl