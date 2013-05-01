ProposalListCtrl = ($scope, $routeParams, $location, proposals, HubSelected) ->
  $scope.hubSelection = HubSelected
  $scope.filterSelection = $routeParams.filter
  $scope.proposals = proposals

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

#  $scope.proposals = HubProposals

#  $scope.hubProposals = Proposal.query
#    filter: $routeParams.filter
#    hub: $routeParams.search

#  submitHubSearch = ->
#    angular.copy($scope.hubProposals, HubProposals)

#  $scope.$watch('hubProposals', submitHubSearch, true)

ProposalListCtrl.$inject = ['$scope', '$routeParams', '$location', 'proposals', 'HubSelected']
angularApp.controller 'ProposalListCtrl', ProposalListCtrl

ProposalViewCtrl = ($scope, $location, proposal) ->
  $scope.proposal = proposal
  console.log(proposal)

ProposalViewCtrl.$inject = ['$scope', '$location', 'proposal']
angularApp.controller 'ProposalViewCtrl', ProposalViewCtrl