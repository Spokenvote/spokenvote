ProposalListCtrl =
  ($scope, $routeParams, $location, proposals, SessionSettings, SpokenvoteCookies) ->
    $scope.proposals = proposals
    $scope.filterSelection = $routeParams.filter
    $scope.spokenvoteSession = SpokenvoteCookies

    $scope.hubSelected = SessionSettings.selectedGroupName

    $scope.setFilter = (filterSelected) ->
      $location.search('filter', filterSelected)


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
  ($scope, $location, AlertService, SessionSettings, VotingService, RelatedProposalsLoader) ->

    $scope.$on 'event:votesChanged', ->
      $scope.relatedProposals.$get()

    RelatedProposalsLoader().then (related_proposals) ->
      $scope.relatedProposals = related_proposals

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
      $location.search('related_sort_by', related_sort_by)
      $scope.relatedProposals.$get()
      $scope.selectedSort = related_sort_by

  # TODO once scolling issue is solved, remove this line and the "RelatedProposals" provider above and enjection below.
  #    $scope.relatedProposals = RelatedProposals.get({id:related_proposals.id,related_sort_by:related_sort_by})

# Injects
ProposalListCtrl.$inject = [ '$scope', '$routeParams', '$location', 'proposals', 'SessionSettings', 'SpokenvoteCookies' ]
ProposalShowCtrl.$inject = [ '$scope', '$location', 'AlertService', 'proposal', 'SessionSettings', 'VotingService' ]
RelatedProposalShowCtrl.$inject = [ '$scope', '$location', 'AlertService', 'SessionSettings', 'VotingService', 'RelatedProposalsLoader' ]

# Register
App.controller 'ProposalListCtrl', ProposalListCtrl
App.controller 'ProposalShowCtrl', ProposalShowCtrl
App.controller 'RelatedProposalShowCtrl', RelatedProposalShowCtrl
