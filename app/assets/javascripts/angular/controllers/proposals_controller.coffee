angularApp.controller "ProposalsCtrl", ($scope, $routeParams, Proposal) ->
  $scope.proposals = Proposal.query({
    filter: $routeParams.filter
  })

  $scope.index = ->
