ProposalsCtrl = ($scope, $routeParams, $location, Proposal, HubSelected, HubProposals) ->
  $scope.searchSelection = HubSelected
  $scope.filterSelection = $routeParams.filter
  $scope.proposals = HubProposals
  $scope.railsProposals = Proposal.query
    filter: $scope.filterSelection

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

  $scope.submitHubSearch = ->
    HubProposals.length = 0
    i = 0
    while i < $scope.railsProposals.length
      HubProposals.push $scope.railsProposals[i]
      i++
    console.log(HubProposals)

ProposalsCtrl.$inject = ['$scope', '$routeParams', '$location', 'Proposal', 'HubSelected', 'HubProposals']
angularApp.controller 'ProposalsCtrl', ProposalsCtrl