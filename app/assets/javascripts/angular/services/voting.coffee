VotingService = [ '$rootScope', '$location', '$modal', 'SessionSettings', 'RelatedVoteInTreeLoader', 'Proposal',
  ( $rootScope, $location, $modal, SessionSettings, RelatedVoteInTreeLoader, Proposal ) ->

    support: ( clicked_proposal ) ->
      $rootScope.sessionSettings.newSupport.target = clicked_proposal
      $rootScope.sessionSettings.newSupport.related = null
      $rootScope.alertService.clearAlerts()

      if !$rootScope.currentUser.id?
        $rootScope.alertService.setInfo 'To support proposals you need to sign in.', scope, 'main'
      else
        RelatedVoteInTreeLoader(clicked_proposal).then (relatedSupport) ->
          if relatedSupport.id?
            $rootScope.sessionSettings.newSupport.related = relatedSupport
            if relatedSupport.proposal.id == clicked_proposal.id
              $rootScope.alertService.setInfo 'Good news, it looks as if you have already supported this proposal. Further editing is not allowed at this time.', $rootScope, 'main'
            else
              if SessionSettings.openModals.supportProposal is false
                modalInstance = $modal.open
                  templateUrl: '/assets/proposals/_support_modal.html'
                  controller: 'SupportCtrl'
                modalInstance.opened.then ->
                  SessionSettings.openModals.supportProposal = true
                modalInstance.result.finally ->
                  SessionSettings.openModals.supportProposal = false

    improve: ( scope, clicked_proposal ) ->
      scope.clicked_proposal = clicked_proposal
      scope.current_user_support = null
      $rootScope.alertService.clearAlerts()

      if !scope.currentUser.id?
        $rootScope.alertService.setInfo 'To improve proposals you need to sign in.', scope, 'main'
      else
        RelatedVoteInTreeLoader(clicked_proposal).then (relatedSupport) ->
          scope.current_user_support = 'related_proposal' if relatedSupport.id?

          if SessionSettings.openModals.improveProposal is false
            modalInstance = $modal.open
              templateUrl: '/assets/proposals/_improve_proposal_modal.html'
              controller: 'ImroveCtrl'
              scope: scope
            modalInstance.opened.then ->
              SessionSettings.openModals.improveProposal = true
            modalInstance.result.finally ->
              SessionSettings.openModals.improveProposal = false

    edit: ( scope, clicked_proposal ) ->
      scope.clicked_proposal = clicked_proposal

      if !scope.currentUser.id?
        $rootScope.alertService.setInfo 'To proceed you need to sign in.', scope, 'main'
      else
        if SessionSettings.openModals.editProposal is false
          modalInstance = $modal.open
            templateUrl: '/assets/proposals/_edit_proposal_modal.html'
            controller: 'EditProposalCtrl'
            scope: scope
          modalInstance.opened.then ->
            SessionSettings.openModals.editProposal = true
          modalInstance.result.finally ->
            SessionSettings.openModals.editProposal = false

    delete: (scope, clicked_proposal) ->
      scope.clicked_proposal = clicked_proposal

      if !scope.currentUser.id?
        $rootScope.alertService.setInfo 'To proceed you need to sign in.', scope, 'main'
      else
        if SessionSettings.openModals.deleteProposal is false
          modalInstance = $modal.open
            templateUrl: '/assets/proposals/_delete_proposal_modal.html'
            controller: 'DeleteProposalCtrl'
            scope: scope
          modalInstance.opened.then ->
            SessionSettings.openModals.deleteProposal = true
          modalInstance.result.finally ->
            SessionSettings.openModals.deleteProposal = false

    new: (scope) ->
      $rootScope.alertService.clearAlerts()
      if SessionSettings.hub_attributes.id?
        SessionSettings.actions.changeHub = false
      else
        SessionSettings.actions.changeHub = true
        SessionSettings.actions.searchTerm = null
      if !$rootScope.currentUser.id?
        $rootScope.alertService.setInfo 'To create proposals you need to sign in.', $rootScope, 'main'
      else
        if SessionSettings.openModals.newProposal is false
          modalInstance = $modal.open
            templateUrl: '/assets/proposals/_new_proposal_modal.html'
            controller: 'NewProposalCtrl'
  #          scope: scope           # Passed in scope was getting clobbered, so letting it set to $rootscope
          modalInstance.opened.then ->
            SessionSettings.openModals.newProposal = true
          modalInstance.result.finally ->
            SessionSettings.openModals.newProposal = false

    wizard: (scope) ->
      if SessionSettings.openModals.getStarted is false
        modalInstance = $modal.open
          templateUrl: '/assets/shared/_get_started_modal.html'
          controller: 'GetStartedCtrl'
        #        scope: scope           # Passed in scope was getting clobbered, so letting it set to $rootscope
        modalInstance.opened.then ->
          SessionSettings.openModals.getStarted = true
        modalInstance.result.finally ->
          SessionSettings.openModals.getStarted = false

    changeHub: (request) ->
      if request = true and SessionSettings.actions.changeHub != 'new'
        SessionSettings.actions.newProposalHub = null
        SessionSettings.actions.changeHub = !SessionSettings.actions.changeHub

    saveNewProposal: ($modalInstance) ->
      if !SessionSettings.hub_attributes.id?
        SessionSettings.hub_attributes.group_name = SessionSettings.actions.searchTerm
      newProposal =
        proposal:
          statement: SessionSettings.newProposal.statement
          votes_attributes:
            comment: SessionSettings.newProposal.comment
          hub_id: SessionSettings.hub_attributes.id
          hub_attributes: SessionSettings.hub_attributes

      $rootScope.alertService.clearAlerts()

      Proposal.save(newProposal
      ,  (response, status, headers, config) ->
        $rootScope.$broadcast 'event:proposalsChanged'
        $rootScope.alertService.setSuccess 'Your new proposal stating: \"' + response.statement + '\" was created.', $rootScope, 'main'
        $location.path('/proposals/' + response.id).search('hub', response.hub_id).search('filter', 'my').hash('navigationBar')
        $modalInstance.close(response)
        SessionSettings.actions.offcanvas = false
      ,  (response, status, headers, config) ->
        $rootScope.alertService.setCtlResult 'Sorry, your new proposal was not saved.', $rootScope, 'modal'
        $rootScope.alertService.setJson response.data
      )

]

# Register
App.Services.factory 'VotingService', VotingService