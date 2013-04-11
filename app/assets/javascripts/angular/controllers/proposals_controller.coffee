angularApp.controller "ProposalsCtrl", ($scope, Proposal) ->
  $scope.proposals = Proposal.query()

  $scope.index = ->
