ProposalListCtrl = ($scope, $routeParams, $location, proposals, current_user, HubSelected, SpokenvoteCookies) ->
  $scope.proposals = proposals
  $scope.currentUser = current_user
  $scope.hubSelection = HubSelected
  $scope.filterSelection = $routeParams.filter
  $scope.spokenvoteSession = SpokenvoteCookies

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

ProposalListCtrl.$inject = ['$scope', '$routeParams', '$location', 'proposals', 'current_user', 'HubSelected', 'SpokenvoteCookies']
angularApp.controller 'ProposalListCtrl', ProposalListCtrl


ProposalShowCtrl = ( $scope, $location, AlertService, proposal, current_user, SessionSettings, VotingService ) ->
  $scope.proposal = proposal
  $scope.currentUser = current_user
  $scope.defaultGravatar = SessionSettings.defaultGravatar

  $scope.support = ( clicked_proposal_id ) ->
    VotingService.support $scope, clicked_proposal_id

  $scope.improve = ( clicked_proposal_id ) ->
    VotingService.improve $scope, clicked_proposal_id

ProposalShowCtrl.$inject = [ '$scope', '$location', 'AlertService', 'proposal', 'current_user', 'SessionSettings', 'VotingService' ]
angularApp.controller 'ProposalShowCtrl', ProposalShowCtrl


RelatedProposalShowCtrl = (RelatedProposals, $scope, $location, AlertService, SessionSettings, VotingService, RelatedProposalsLoader) ->

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

RelatedProposalShowCtrl.$inject = [ 'RelatedProposals', '$scope', '$location', 'AlertService', 'SessionSettings', 'VotingService', 'RelatedProposalsLoader' ]
angularApp.controller 'RelatedProposalShowCtrl', RelatedProposalShowCtrl
