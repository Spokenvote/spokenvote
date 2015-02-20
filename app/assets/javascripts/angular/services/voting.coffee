VotingService = [ '$rootScope', '$location', '$modal', 'RelatedVoteInTreeLoader', 'Proposal', 'Focus', ( $rootScope, $location, $modal, RelatedVoteInTreeLoader, Proposal, Focus ) ->

  support: ( clicked_proposal ) ->
    $rootScope.sessionSettings.newSupport.target = clicked_proposal
    $rootScope.sessionSettings.newSupport.related = null
    $rootScope.alertService.clearAlerts()

    if !$rootScope.currentUser.id?
      $rootScope.alertService.setInfo 'To support proposals you need to sign in.', $rootScope, 'main'
    else
      RelatedVoteInTreeLoader(clicked_proposal).then (relatedSupport) ->
        if relatedSupport.id?
          $rootScope.sessionSettings.newSupport.related = relatedSupport
          if relatedSupport.proposal.id == clicked_proposal.id
            $rootScope.alertService.setInfo 'Good news, it looks as if you have already supported this proposal. Further editing is not allowed at this time.', $rootScope, 'main'
            return
        $rootScope.sessionSettings.actions.newProposal.comment = clicked_proposal.id
        Focus '#new_vote_comment'

#        if $rootScope.sessionSettings.openModals.supportProposal is false
#          modalInstance = $modal.open
#            templateUrl: 'proposals/_support_modal.html'
#            controller: 'SupportCtrl'
#          modalInstance.opened.then ->
#            $rootScope.sessionSettings.openModals.supportProposal = true
#          modalInstance.result.finally ->
#            $rootScope.sessionSettings.openModals.supportProposal = false

#  improve: ( scope, clicked_proposal ) ->
  improve: ( clicked_proposal ) ->
#    scope.clicked_proposal = clicked_proposal
#    scope.current_user_support = null
    $rootScope.alertService.clearAlerts()

    if !$rootScope.currentUser.id?
      $rootScope.alertService.setInfo 'To improve proposals you need to sign in.', $rootScope, 'main'
    else
      RelatedVoteInTreeLoader(clicked_proposal).then (relatedSupport) ->
#        scope.current_user_support = 'related_proposal' if relatedSupport.id?
        if relatedSupport.id?
          $rootScope.alertService.setInfo 'We found support from you on another proposal. If you create a new, improved propsal your previous support will be moved here.', $rootScope, 'main'

        $rootScope.sessionSettings.actions.improveProposal = clicked_proposal
        Focus '#improved_proposal_statement'

#        if $rootScope.sessionSettings.openModals.improveProposal is false
#          modalInstance = $modal.open
#            templateUrl: 'proposals/_improve_proposal_modal.html'
#            controller: 'ImproveCtrl'
#            scope: scope
#          modalInstance.opened.then ->
#            $rootScope.sessionSettings.openModals.improveProposal = true
#          modalInstance.result.finally ->
#            $rootScope.sessionSettings.openModals.improveProposal = false

  edit: ( scope, clicked_proposal ) ->
    scope.clicked_proposal = clicked_proposal

    if !scope.currentUser.id?
      $rootScope.alertService.setInfo 'To proceed you need to sign in.', $rootScope, 'main'
    else
      if $rootScope.sessionSettings.openModals.editProposal is false
        modalInstance = $modal.open
          templateUrl: 'proposals/_edit_proposal_modal.html'
          controller: 'EditProposalCtrl'
          scope: scope      # Optional to pass the scope here?
        modalInstance.opened.then ->
          $rootScope.sessionSettings.openModals.editProposal = true
        modalInstance.result.finally ->
          $rootScope.sessionSettings.openModals.editProposal = false

  delete: (scope, clicked_proposal) ->
    scope.clicked_proposal = clicked_proposal

    if !scope.currentUser.id?
      $rootScope.alertService.setInfo 'To proceed you need to sign in.', $rootScope, 'main'
    else
      if $rootScope.sessionSettings.openModals.deleteProposal is false
        modalInstance = $modal.open
          templateUrl: 'proposals/_delete_proposal_modal.html'
          controller: 'DeleteProposalCtrl'
          scope: scope       # Optional to pass the scope here?
        modalInstance.opened.then ->
          $rootScope.sessionSettings.openModals.deleteProposal = true
        modalInstance.result.finally ->
          $rootScope.sessionSettings.openModals.deleteProposal = false

#  new: (scope) ->
  new: ->
    $rootScope.alertService.clearAlerts()
    $rootScope.sessionSettings.actions.newProposal.started = false
#    if $rootScope.sessionSettings.hub_attributes.id?
#      $rootScope.sessionSettings.actions.changeHub = false
#    else
#      $rootScope.sessionSettings.actions.changeHub = true
#      $rootScope.sessionSettings.actions.searchTerm = null
    if !$rootScope.currentUser.id?
      $rootScope.alertService.setInfo 'To create proposals you need to sign in.', $rootScope, 'main'
    else
      $location.path '/start'
#      if $rootScope.sessionSettings.openModals.newProposal is false
#        modalInstance = $modal.open
#          templateUrl: 'proposals/_new_proposal_modal.html'
#          controller: 'NewProposalCtrl'
#        modalInstance.opened.then ->
#          $rootScope.sessionSettings.openModals.newProposal = true
#        modalInstance.result.finally ->
#          $rootScope.sessionSettings.openModals.newProposal = false

  wizard: (scope) ->
    if $rootScope.sessionSettings.openModals.getStarted is false
      modalInstance = $modal.open
        templateUrl: 'shared/_get_started_modal.html'
        controller: 'GetStartedCtrl'
      #        scope: scope           # Passed in scope was getting clobbered, so letting it set to $rootscope
      modalInstance.opened.then ->
        $rootScope.sessionSettings.openModals.getStarted = true
      modalInstance.result.finally ->
        $rootScope.sessionSettings.openModals.getStarted = false

  changeHub: (request) ->
    if request is true and $rootScope.sessionSettings.actions.changeHub != 'new'
      $rootScope.sessionSettings.actions.newProposalHub = null
      $rootScope.sessionSettings.actions.changeHub = !$rootScope.sessionSettings.actions.changeHub

#  saveNewProposal: ($modalInstance) ->
  saveNewProposal: ->
#    console.log 'voting service: saveNewProposal'
    $rootScope.alertService.clearAlerts()

    if !$rootScope.sessionSettings.hub_attributes.id?
      if $rootScope.sessionSettings.hub_attributes.formatted_location? and $rootScope.sessionSettings.actions.searchTerm?
        $rootScope.sessionSettings.hub_attributes.group_name = $rootScope.sessionSettings.actions.searchTerm
      else
        $rootScope.alertService.setCtlResult 'Sorry, your New Group location appears to be invalid.', $rootScope, 'main'
        return
    newProposal =
      proposal:
        statement: $rootScope.sessionSettings.newProposal.statement
        votes_attributes:
          comment: $rootScope.sessionSettings.newProposal.comment
        hub_id: $rootScope.sessionSettings.hub_attributes.id
        hub_attributes: $rootScope.sessionSettings.hub_attributes

    Proposal.save(
      (newProposal
      ), ((response, status, headers, config) ->
        $rootScope.$broadcast 'event:proposalsChanged'
        $rootScope.alertService.setSuccess 'Your new proposal stating: \"' + response.statement + '\" was created.', $rootScope, 'main'
        $location.path('/proposals/' + response.id).search('hub', response.hub_id).search('filter', 'my')   # Angular empty hash bug
#        $location.path('/proposals/' + response.id).search('hub', response.hub_id).search('filter', 'my').hash('navigationBar')
#        $modalInstance.close(response)
        $rootScope.sessionSettings.actions.offcanvas = false
      ),  (response, status, headers, config) ->
        $rootScope.alertService.setCtlResult 'Sorry, your new proposal was not saved.', $rootScope, 'modal'
        $rootScope.alertService.setJson response.data
    )

]

# Register
App.Services.factory 'VotingService', VotingService