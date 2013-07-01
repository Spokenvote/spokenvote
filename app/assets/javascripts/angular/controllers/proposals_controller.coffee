ProposalListCtrl =
  ($scope, $routeParams, $location, proposals, SessionSettings, SpokenvoteCookies, VotingService) ->
    $scope.proposals = proposals
    $scope.filterSelection = $routeParams.filter
    $scope.spokenvoteSession = SpokenvoteCookies

    $scope.setFilter = (filterSelected) ->
      $location.search('filter', filterSelected)

    $scope.setHub = (hubSelected) ->
      $location.search('hub', hubSelected.id)

    $scope.$on 'event:proposalsChanged', ->
      $scope.proposals.$query
      console.log $scope.proposals

    $scope.new = ->
      if $scope.sessionSettings.hub_attributes.id?
        $scope.sessionSettings.actions.changeHub = false
      else
        $scope.sessionSettings.actions.searchTerm = null
        $scope.sessionSettings.actions.changeHub = true
      VotingService.new $scope


ProposalShowCtrl = ( $scope, $location, AlertService, VotingService , proposal, relatedProposals) ->
  $scope.proposal = proposal
  $scope.relatedProposals = relatedProposals

  $scope.$on 'event:votesChanged', ->
    $scope.proposal.$get()

  $scope.hubView = ->
    $location.path('/proposals').search('hub', proposal.hub.id)

  $scope.setVoter = (vote) ->
    $location.path('/proposals').search('user', vote.user_id)
    $scope.sessionSettings.actions.userFilter = vote.username

  $scope.support = ( clicked_proposal_id ) ->
    VotingService.support $scope, clicked_proposal_id

  $scope.improve = ( clicked_proposal_id ) ->
    VotingService.improve $scope, clicked_proposal_id

  $scope.edit = ( clicked_proposal ) ->
    VotingService.edit $scope, clicked_proposal

  $scope.delete = ( clicked_proposal ) ->
    VotingService.delete $scope, clicked_proposal

  $scope.tooltips =
    support: "<h5><b>Support this proposal</b></h4><b>Supporting:</b> You may support only one proposal on this topic,
              but are free to change your support to a <i>different</i> proposal at any time by clicking
              <i>support</i> on that proposal or by composing an <i>improved</i> proposal."
    improve: "<h5><b>Create a better proposal</b></h4><b>Improving:</b>
              By composing an <i>improved</i> proposal you automatically become that proposal's first supporter.
              You may change your support to a <i>different</i> proposal at any time by
              supporting it or by composing another <i>improved</i> proposal."
    edit: "<h5><b>Edit your proposal</b></h4><b>Editing: </b>You may edit your proposal<br />
            up until it receives its first support from<br />another user."
    delete: "<h5><b>Delete your proposal</b></h4><b>Deleting: </b>You may delete your<br />proposal
                up until it receives its first<br />support from another user or if support<br /> ever falls to zero."
    twitter: 'Share this proposal on Twitter'
    facebook: 'Share this proposal on Facebook'
    google: 'Share this proposal on Google+'

  $scope.socialSharing =
    twitterUrl: $scope.sessionSettings.socialSharing.twitterRootUrl + 'Check out this Spokenvote proposal:' + $scope.location.absUrl() + ' /via @spokenvote'
    facebookUrl: $scope.sessionSettings.socialSharing.facebookRootUrl + $scope.location.absUrl()
    googleUrl: $scope.sessionSettings.socialSharing.googleRootUrl + $scope.location.absUrl()


RelatedProposalShowCtrl = ( $scope ) ->

    $scope.$on 'event:votesChanged', ->
      $scope.relatedProposals.$get()

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
      $scope.relatedProposals.$get
        id: $scope.proposal.id
        related_sort_by: related_sort_by
      $scope.selectedSort = related_sort_by

# Injects
ProposalListCtrl.$inject = [ '$scope', '$routeParams', '$location', 'proposals', 'SessionSettings', 'SpokenvoteCookies', 'VotingService' ]
ProposalShowCtrl.$inject = [ '$scope', '$location', 'AlertService', 'VotingService', 'proposal', 'relatedProposals' ]
RelatedProposalShowCtrl.$inject = [ '$scope' ]

# Register
App.controller 'ProposalListCtrl', ProposalListCtrl
App.controller 'ProposalShowCtrl', ProposalShowCtrl
App.controller 'RelatedProposalShowCtrl', RelatedProposalShowCtrl
