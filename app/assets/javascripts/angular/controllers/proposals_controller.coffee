angularApp.controller "ProposalsCtrl", ($scope, $routeParams, Proposal) ->
  $scope.proposals = Proposal.query({
    filter: $scope.filter
  })

  $scope.index = ->

  $scope.setFilter = (filterSelecton) ->
    $scope.proposals = Proposal.query({
      filter: filterSelecton
    })
    console.log($scope.filter)

  $scope.setClass = 'btn active'
