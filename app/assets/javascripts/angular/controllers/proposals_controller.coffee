ProposalListCtrl = ($scope, $routeParams, $location, proposals, HubSelected, HubProposals) ->
  $scope.filterSelection = $routeParams.filter
  $scope.hubSelection = HubSelected
  $scope.proposals = HubProposals

#  Proposal.get(id: $routeParams.id)

  $scope.hubProposals = proposals

#  $scope.hubProposals = Proposal.query
#    filter: $routeParams.filter
#    hub: $routeParams.search

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

  submitHubSearch = ->
    angular.copy($scope.hubProposals, HubProposals)

  $scope.$watch('hubProposals', submitHubSearch, true)

ProposalListCtrl.$inject = ['$scope', '$routeParams', '$location', 'proposals', 'HubSelected', 'HubProposals']
angularApp.controller 'ProposalListCtrl', ProposalListCtrl

ProposalViewCtrl = ($scope, $location, proposal) ->
  $scope.proposal = proposal

ProposalViewCtrl.$inject = ['$scope', '$location', 'proposal']
angularApp.controller 'ProposalViewCtrl', ProposalViewCtrl