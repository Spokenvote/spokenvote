angularApp.controller "ProposalsCtrl", ($scope, $routeParams, Proposal) ->
  $scope.filterSelection = 'active'
  $scope.proposals = Proposal.query
    filter: $scope.filterSelection


  $scope.index = ->

  $scope.setFilter = (filterSelection) ->
    $scope.proposals = Proposal.query
      filter: filterSelection

#  $scope.setClass = 'btn active'
