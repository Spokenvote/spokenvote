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
    $location
      .search 'filter', filterSelected

  $scope.setHub = (hubSelected) ->
    $location
      .path '/proposals/'
      .search 'hub', hubSelected.id
]

ProposalShowCtrl = [ '$scope', '$location', '$sce', 'proposal', 'relatedProposals', 'svUtility', ( $scope, $location, $sce , proposal, relatedProposals, svUtility) ->
  $scope.proposal = proposal
  $scope.relatedProposals = relatedProposals
  $scope.sessionSettings.actions.detailPage = true

  if not $scope.sessionSettings.hub_attributes
    $scope.sessionSettings.hub_attributes = proposal.hub
    $location.search 'hub', proposal.hub.id

  $scope.$on 'event:votesChanged', ->
    $scope.proposal.$get()

  $scope.setVoter = ( vote ) ->
    $location
      .path '/proposals'
      .search 'user', vote.user_id
    $scope.sessionSettings.actions.userFilter = vote.username

  $scope.tooltips =
    support: $sce.trustAsHtml "<h6><b>Support this proposal</b></h6><b>Supporting:</b> You may support only one proposal on this topic,
              but are free to change your support to a <i>different</i> proposal at any time by clicking
              <i>support</i> on that proposal or by composing an <i>improved</i> proposal."
    improve: $sce.trustAsHtml "<h6><b>Create a better proposal</b></h6><b>Improving:</b>
              By composing an <i>improved</i> proposal you automatically become that proposal's first supporter.
              You may change your support to a <i>different</i> proposal at any time by
              supporting it or by composing another <i>improved</i> proposal."
    edit: $sce.trustAsHtml "<h6><b>Edit your proposal</b></h6><b>Editing: </b>You may edit your proposal<br />
            up until it receives its first support from<br />another user."
    delete: $sce.trustAsHtml "<h6><b>Delete your proposal</b></h6><b>Deleting: </b>You may delete your<br />proposal
                up until it receives its first<br />support from another user or if support<br /> ever falls to zero."

    support: $sce.trustAsHtml "<h6><b>Support this proposal</b></h6><b>Supporting:</b> You may support only one proposal on this topic,
              but are free to change your support to a <i>different</i> proposal at any time by clicking
              <i>support</i> on that proposal or by composing an <i>improved</i> proposal."
    improve: $sce.trustAsHtml "<h6><b>Create a better proposal</b></h6><b>Improving:</b>
              By composing an <i>improved</i> proposal you automatically become that proposal's first supporter.
              You may change your support to a <i>different</i> proposal at any time by
              supporting it or by composing another <i>improved</i> proposal."
    edit: $sce.trustAsHtml "<h6><b>Edit your proposal</b></h6><b>Editing: </b>You may edit your proposal<br />
            up until it receives its first support from<br />another user."
    delete: $sce.trustAsHtml "<h6><b>Delete your proposal</b></h6><b>Deleting: </b>You may delete your<br />proposal
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
