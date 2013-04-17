angularApp.controller "ProposalsCtrl", ($scope, $routeParams, $location, Proposal) ->
  $scope.filterSelection = $routeParams.filter
  $scope.proposals = Proposal.query
    filter: $scope.filterSelection

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)


