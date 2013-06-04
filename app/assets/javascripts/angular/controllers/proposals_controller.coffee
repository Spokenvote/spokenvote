ProposalListCtrl =
  ($scope, $routeParams, $location, proposals, SessionSettings, SpokenvoteCookies, VotingService) ->
    $scope.proposals = proposals
    $scope.filterSelection = $routeParams.filter
    $scope.spokenvoteSession = SpokenvoteCookies

    $scope.sessionSettings = SessionSettings

    $scope.setFilter = (filterSelected) ->
      $location.search('filter', filterSelected)

    $scope.new = ->
      VotingService.new $scope


ProposalShowCtrl = ( $scope, $location, AlertService, proposal, SessionSettings, VotingService ) ->
  $scope.proposal = proposal
  $scope.defaultGravatar = SessionSettings.defaultGravatar

  $scope.$on 'event:votesChanged', ->
    $scope.proposal.$get()

  $scope.support = ( clicked_proposal_id ) ->
    VotingService.support $scope, clicked_proposal_id

  $scope.improve = ( clicked_proposal_id ) ->
    VotingService.improve $scope, clicked_proposal_id


RelatedProposalShowCtrl =
  ($scope, $location, AlertService, SessionSettings, VotingService, RelatedProposals) ->

    $scope.$on 'event:votesChanged', ->
      $scope.relatedProposals.$get()

    $scope.relatedProposals = RelatedProposals.get({id: $scope.proposal.id})

    $scope.related_sorter_dropdown = [
      text: "By Votes"
      submenu: [
        text: "Most Votes"
        click: "sortRelatedProposals('Most Votes')"
      ,
        text: "Least Votes"
        click: "sortRelatedProposals('Least Votes')"
      ]
    ,
      text: "By Age"
      submenu: [
        text: "Most Recently Voted on"
        click: "sortRelatedProposals('Most Recently Voted on')"
      ,
        text: "Oldest Most Recent Vote"
        click: "sortRelatedProposals('Oldest Most Recent Vote')"
      ]
    ]

    $scope.sortRelatedProposals = (related_sort_by) ->
      $scope.relatedProposals = RelatedProposals.get({id: $scope.proposal.id, related_sort_by: related_sort_by})
      $scope.selectedSort = related_sort_by

# Injects
ProposalListCtrl.$inject = [ '$scope', '$routeParams', '$location', 'proposals', 'SessionSettings', 'SpokenvoteCookies', 'VotingService' ]
ProposalShowCtrl.$inject = [ '$scope', '$location', 'AlertService', 'proposal', 'SessionSettings', 'VotingService' ]
RelatedProposalShowCtrl.$inject = [ '$scope', '$location', 'AlertService', 'SessionSettings', 'VotingService', 'RelatedProposals' ]

# Register
App.controller 'ProposalListCtrl', ProposalListCtrl
App.controller 'ProposalShowCtrl', ProposalShowCtrl
App.controller 'RelatedProposalShowCtrl', RelatedProposalShowCtrl
