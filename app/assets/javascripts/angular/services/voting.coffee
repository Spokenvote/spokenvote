VotingService = ( $modal, AlertService, RelatedVoteInTreeLoader ) ->

  support: ( scope, clicked_proposal_id ) ->
    scope.clicked_proposal_id = clicked_proposal_id
    scope.current_user_support = null

    RelatedVoteInTreeLoader(clicked_proposal_id).then (relatedSupport) ->
      if relatedSupport.id?
        if relatedSupport.proposal.id == clicked_proposal_id
          scope.current_user_support = 'this_proposal'
        else
          scope.current_user_support = 'related_proposal'
      if scope.current_user_support == 'this_proposal'
        AlertService.setCtlResult 'Good news, it looks as if you have already supported this proposal. Further editing is not supported at this time.'
      else
        $modal
          template: '/assets/proposals/_support_modal.html.haml'
          show: true
          backdrop: 'static'
          scope: scope

  improve: ( scope, clicked_proposal_id ) ->
    scope.clicked_proposal_id = clicked_proposal_id
    scope.current_user_support = null

    RelatedVoteInTreeLoader(clicked_proposal_id).then (relatedSupport) ->
      if relatedSupport.id?
        scope.current_user_support = 'related_proposal'
      $modal
        template: '/assets/proposals/_improve_proposal_modal.html.haml'
        show: true
        backdrop: 'static'
        scope: scope


# Injects
VotingService.$inject = [ '$modal', 'AlertService', 'RelatedVoteInTreeLoader'  ]

# Register
App.Services.factory 'VotingService', VotingService