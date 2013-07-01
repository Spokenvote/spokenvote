VotingService = ( $dialog, AlertService, SessionSettings, RelatedVoteInTreeLoader ) ->

  support: ( scope, clicked_proposal ) ->
    scope.clicked_proposal = clicked_proposal
    scope.current_user_support = null

    if !scope.currentUser.id?
      AlertService.setInfo 'To support proposals you need to sign in.', scope, 'modal'
      scope.signInModal 'VotingService.support', scope, clicked_proposal.id   #TODO Preparing for Friendly Forwarding, but need some coaching on best practices.
    else
      RelatedVoteInTreeLoader(clicked_proposal.id).then (relatedSupport) ->
        if relatedSupport.id?
          if relatedSupport.proposal.id == clicked_proposal.id
            scope.current_user_support = 'this_proposal'
          else
            scope.current_user_support = 'related_proposal'
        if scope.current_user_support == 'this_proposal'
          AlertService.setInfo 'Good news, it looks as if you have already supported this proposal. Further editing is not allowed at this time.', scope, 'main'
        else
          if SessionSettings.openModals.supportProposal is false
            scope.opts =
              resolve:
                $scope: ->
                  scope
            d = $dialog.dialog(scope.opts)
            SessionSettings.openModals.supportProposal = true
            d.open('/assets/proposals/_support_modal.html.haml', 'SupportCtrl').then (result) ->
              SessionSettings.openModals.supportProposal = d.isOpen()


  improve: ( scope, clicked_proposal ) ->
    scope.clicked_proposal = clicked_proposal
    scope.current_user_support = null

    if !scope.currentUser.id?
      scope.signInModal()
      AlertService.setInfo 'To improve proposals you need to sign in.', scope, 'modal'
    else
      RelatedVoteInTreeLoader(clicked_proposal.id).then (relatedSupport) ->
        scope.current_user_support = 'related_proposal' if relatedSupport.id?

      if SessionSettings.openModals.improveProposal is false
        scope.opts =
          resolve:
            $scope: ->
              scope
        d = $dialog.dialog(scope.opts)
        SessionSettings.openModals.improveProposal = true
        d.open('/assets/proposals/_improve_proposal_modal.html.haml', 'ImroveCtrl').then (result) ->
          SessionSettings.openModals.improveProposal = d.isOpen()


  edit: ( scope, clicked_proposal ) ->
    scope.clicked_proposal = clicked_proposal

    if SessionSettings.openModals.editProposal is false
      scope.opts =
        resolve:
          parentScope: ->
            scope
      d = $dialog.dialog(scope.opts)
      SessionSettings.openModals.editProposal = true
      d.open('/assets/proposals/_edit_proposal_modal.html.haml', 'EditProposalCtrl').then (result) ->
        SessionSettings.openModals.editProposal = d.isOpen()

  delete: ( scope, clicked_proposal ) ->
    scope.clicked_proposal = clicked_proposal

    if SessionSettings.openModals.newProposal is false
      scope.opts =
        resolve:
          parentScope: ->
            scope
      d = $dialog.dialog(scope.opts)
      SessionSettings.openModals.deleteProposal = true
      d.open('/assets/proposals/_delete_proposal_modal.html.haml', 'DeleteProposalCtrl').then (result) ->
        SessionSettings.openModals.deleteProposal = d.isOpen()

  new: ( scope ) ->
    if SessionSettings.openModals.newProposal is false
      scope.opts =
        resolve:
          parentScope: ->
            scope
      d = $dialog.dialog(scope.opts)
      SessionSettings.openModals.newProposal = true
      d.open('/assets/proposals/_new_proposal_modal.html.haml', 'NewProposalCtrl').then (result) ->
        SessionSettings.openModals.newProposal = d.isOpen()

# Injects
VotingService.$inject = [ '$dialog', 'AlertService', 'SessionSettings', 'RelatedVoteInTreeLoader'  ]

# Register
App.Services.factory 'VotingService', VotingService