angularApp.controller "ProposalsCtrl", ($scope, $routeParams, Proposal) ->
  $scope.filterSelection = 'Active'
  $scope.proposals = Proposal.query
    filter: $scope.filterSelection

  $scope.index = ->

  $scope.setFilter = (filterSelected) ->
    $scope.proposals = Proposal.query
      filter: filterSelected

