ProposalListCtrl = [ '$scope', '$location', 'MultiProposalLoader', 'SpokenvoteCookies', ( $scope, $location, MultiProposalLoader, SpokenvoteCookies ) ->
  $scope.proposalsLoading = true
  MultiProposalLoader().then (proposals) ->
    $scope.proposals = proposals
    $scope.proposalsLoading = false
  $scope.spokenvoteSession = SpokenvoteCookies
  $scope.sessionSettings.actions.detailPage = false

  $scope.$on 'event:proposalsChanged', ->
    $scope.proposals.$query

  $scope.setFilter = (filterSelected) ->
    $location.search('filter', filterSelected)

  $scope.setHub = (hubSelected) ->
    $location.path('/proposals/').search('hub', hubSelected.id)
]

ProposalShowCtrl = [ '$scope', '$location', 'proposal', 'relatedProposals', 'Focus', ( $scope, $location , proposal, relatedProposals, Focus) ->
  $scope.proposal = proposal
  $scope.relatedProposals = relatedProposals
  $scope.sessionSettings.actions.detailPage = true
  if proposal.id
    $scope.sessionSettings.actions.hubPlaceholder = 'Find and go to another group ...'
  else
    $scope.sessionSettings.actions.hubPlaceholder = 'Who should see your proposal? ...'

  $scope.sessionSettings.actions.hubShow = false  unless $scope.sessionSettings.routeParams.hub or $scope.sessionSettings.actions.newProposal.started
  $scope.sessionSettings.actions.newProposal.started = true

  $scope.$on 'event:votesChanged', ->
    $scope.proposal.$get()

  $scope.commentStep = ( proposal_id)  ->                             # Refactor Proposal Area Ticket
#    console.log 'comment step: '
    $scope.sessionSettings.actions.focus = 'comment'
    Focus '#new_vote_comment'

#  $scope.hubStep = ->                                                # Why did I put hubStep here?
#    $scope.sessionSettings.actions.newProposal.comment = 'complete'
#    $scope.sessionSettings.actions.newProposal.hub = 'active'  unless $scope.sessionSettings.hub_attributes.id
#    if $scope.newProposalForm.$valid and $scope.sessionSettings.hub_attributes.id
#      $scope.sessionSettings.actions.focus = 'publish'
#      Focus 'publish'
#    else if $scope.sessionSettings.hub_attributes.id
#      $scope.alertService.setError 'The proposal is not quite right, too short perhaps?', $scope, 'main'

#  $scope.finishProp = ->                                             # Proposal Edit, Improve and New should share a similar final save UX
#    $scope.sessionSettings.actions.newProposal.hub = 'complete'
#    $scope.sessionSettings.actions.focus = 'publish'
#    Focus 'publish'

  $scope.setVoter = ( vote ) ->
    $location.path('/proposals').search('user', vote.user_id)
    $scope.sessionSettings.actions.userFilter = vote.username

  $scope.support = ( clicked_proposal ) ->
    if $scope.currentUser.id?
      $scope.votingService.support clicked_proposal
    else
      $scope.authService.signinFb($scope).then ->
        $scope.votingService.support clicked_proposal

  $scope.improve = ( clicked_proposal ) ->
    if $scope.currentUser.id?
      $scope.votingService.improve clicked_proposal
#      $scope.votingService.improve $scope, clicked_proposal
    else
      $scope.authService.signinFb($scope).then ->
        $scope.votingService.improve clicked_proposal
#        $scope.votingService.improve $scope, clicked_proposal

  $scope.edit = ( clicked_proposal ) ->
    $scope.votingService.edit $scope, clicked_proposal

  $scope.delete = ( clicked_proposal ) ->
    $scope.votingService.delete $scope, clicked_proposal

  $scope.tooltips =
    support: "<h6><b>Support this proposal</b></h6><b>Supporting:</b> You may support only one proposal on this topic,
              but are free to change your support to a <i>different</i> proposal at any time by clicking
              <i>support</i> on that proposal or by composing an <i>improved</i> proposal."
    improve: "<h6><b>Create a better proposal</b></h6><b>Improving:</b>
              By composing an <i>improved</i> proposal you automatically become that proposal's first supporter.
              You may change your support to a <i>different</i> proposal at any time by
              supporting it or by composing another <i>improved</i> proposal."
    edit: "<h6><b>Edit your proposal</b></h6><b>Editing: </b>You may edit your proposal<br />
            up until it receives its first support from<br />another user."
    delete: "<h6><b>Delete your proposal</b></h6><b>Deleting: </b>You may delete your<br />proposal
                up until it receives its first<br />support from another user or if support<br /> ever falls to zero."
    twitter: 'Share this proposal on Twitter'
    facebook: 'Share this proposal on Facebook'
    google: 'Share this proposal on Google+'
#      backtoTopics: 'Return to Topic list'

  $scope.socialSharing =
    twitterUrl: $scope.sessionSettings.socialSharing.twitterRootUrl + 'Check out this Spokenvote proposal:' + $scope.location.absUrl() + ' /via @spokenvote'
    facebookUrl: $scope.sessionSettings.socialSharing.facebookRootUrl + $scope.location.absUrl()
    googleUrl: $scope.sessionSettings.socialSharing.googleRootUrl + $scope.location.absUrl()
]

RelatedProposalShowCtrl = [ '$scope', ( $scope ) ->

  $scope.$on 'event:votesChanged', ->
    $scope.relatedProposals.$get()

  $scope.related_sorter_dropdown = [
    {
      text: "By Votes"
      submenu:
        [
          {
            text: "Most Votes"
            click: "sortRelatedProposals('Most Votes')"
          },
          {
            text: "Least Votes"
            click: "sortRelatedProposals('Least Votes')"
          }
        ]
    },
    {
      text: "By Age"
      submenu:
        [
          {
            text: "Most Recently Voted on"
            click: "sortRelatedProposals('Most Recently Voted on')"
          },
          {
            text: "Oldest Most Recent Vote"
            click: "sortRelatedProposals('Oldest Most Recent Vote')"
          }
        ]
    }
  ]

  $scope.sortRelatedProposals = (related_sort_by) ->
    $scope.relatedProposals.$get
      id: $scope.proposal.id
      related_sort_by: related_sort_by
    $scope.selectedSort = related_sort_by
]

# Register
App.controller 'ProposalListCtrl', ProposalListCtrl
App.controller 'ProposalShowCtrl', ProposalShowCtrl
App.controller 'RelatedProposalShowCtrl', RelatedProposalShowCtrl
