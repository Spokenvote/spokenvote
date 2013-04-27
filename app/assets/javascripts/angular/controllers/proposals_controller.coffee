ProposalsCtrl = ($scope, $routeParams, $location, Proposal, HubSelected, HubProposals) ->
  $scope.filterSelection = $routeParams.filter
  $scope.hubSelection = HubSelected
  $scope.proposals = HubProposals

  Proposal.get(id: $routeParams.id)

  $scope.hubProposals = Proposal.query
    filter: $routeParams.filter
    hub: $routeParams.search

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

  submitHubSearch = ->
    angular.copy($scope.hubProposals, HubProposals)

  $scope.$watch('hubProposals', submitHubSearch, true)

ProposalsCtrl.$inject = ['$scope', '$routeParams', '$location', 'Proposal', 'HubSelected', 'HubProposals']
angularApp.controller 'ProposalsCtrl', ProposalsCtrl

ProposalsShowCtrl = ($scope, $routeParams, $location, Proposal) ->
  $scope.proposal = Proposal.get
    id: $routeParams.id
  , (proposal) ->
      console.log(proposal.votes)
#      $scope.proposal = proposal

ProposalsShowCtrl.$inject = ['$scope', '$routeParams', '$location', 'Proposal']
angularApp.controller 'ProposalsShowCtrl', ProposalsShowCtrl