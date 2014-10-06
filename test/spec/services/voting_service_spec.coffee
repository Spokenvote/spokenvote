describe 'Voting Service Tests', ->
  beforeEach ->
    module 'spokenvote'

  describe 'VotingService should perform Voting Service tasks', ->
    $rootScope = undefined
    $httpBackend = undefined
    VotingService = undefined
    Proposal = undefined
#    $location = undefined
    $modal = undefined
    modalInstance = undefined
    scope = undefined
#    mockProposal =
#      id: 1
#      statement: 'My Proposal'
#    mockRelatedProposals = [ 1, 2, 3 ]
    clicked_proposal =
      id: 17
      proposal:
        statement: 'My proposal statement'
        votes_attributes:
          comment: 'Why you should vote for this proposal'
    relatedSupport =
      id: 122
      proposal:
        id: 8
        statement: 'Related proposal statement'
        votes_attributes:
          comment: 'Why you should vote for this related proposal'

    beforeEach inject (_$rootScope_, _$httpBackend_, _VotingService_, _SessionSettings_, _$modal_, _Proposal_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $modal = _$modal_
      VotingService = _VotingService_
      Proposal = _Proposal_
      $rootScope.sessionSettings = _SessionSettings_
      $rootScope.alertService =
        clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
        setInfo: jasmine.createSpy 'alertService:setInfo'
        setCtlResult: jasmine.createSpy 'alertService:setCtlResult'
      $rootScope.currentUser =
        id: 5
      scope = $rootScope.$new()
      modalInstance =
        opened:
          then: (openedCallback) ->
            openedCallback()
        result:
          finally: (callback) ->
            @finallyCallback = callback

      spyOn $modal, 'open'
        .and.returnValue modalInstance

    it 'should initialize methods', ->
      expect VotingService.support
        .toBeDefined()
      expect VotingService.improve
        .toBeDefined()
      expect VotingService.edit
        .toBeDefined()
      expect VotingService.delete
        .toBeDefined()
      expect VotingService.new
        .toBeDefined()
      expect VotingService.wizard
        .toBeDefined()
      expect VotingService.changeHub
        .toBeDefined()
      expect VotingService.saveNewProposal
        .toBeDefined()


    describe 'SUPPORT method should make checks and open SUPPORT modal', ->

      it 'should initialize SUPPORT method', ->
        VotingService.support clicked_proposal

        expect $rootScope.sessionSettings.newSupport.target
          .toEqual clicked_proposal
        expect $rootScope.sessionSettings.newSupport.related
          .toBe null
        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1

      it 'should invoke sign-in warning if user manages to somehow get here to SUPPORT a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null
        VotingService.support clicked_proposal

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1

      it 'should check and FIND an existing vote from THIS user on THIS proposal', ->
        relatedSupport.proposal.id = 17
        $rootScope.sessionSettings.newSupport.related = null
        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        expect $rootScope.sessionSettings.newSupport.related
          .toEqual jasmine.objectContaining relatedSupport
        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setInfo
          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)

      it 'should check and FIND NO existing vote from THIS user on THIS proposal, then open modal', ->

        expect $rootScope.sessionSettings.openModals.supportProposal
          .toEqual false

        relatedSupport.proposal.id = 8
        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        openModalArgs =
          templateUrl: 'proposals/_support_modal.html'
          controller: 'SupportCtrl'

        expect $rootScope.sessionSettings.newSupport.related.proposal.id    # Probably not relevant
          .not.toEqual 17
        expect $modal.open
          .toHaveBeenCalledWith openModalArgs
        expect modalInstance.opened.then
          .toHaveBeenCalled
        expect modalInstance.result.finally
          .toHaveBeenCalled
        expect $rootScope.sessionSettings.openModals.supportProposal
          .toEqual true

        modalInstance.result.finallyCallback()

        expect $rootScope.sessionSettings.openModals.supportProposal
          .toEqual false


    describe 'IMPROVE method should make checks and open IMPROVE modal', ->

      it 'should initialize IMPROVE method', ->
        VotingService.improve scope, clicked_proposal

        expect scope.clicked_proposal
          .toEqual clicked_proposal
        expect scope.current_user_support
          .toEqual null
        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1

      it 'should invoke sign-in warning if user manages to somehow get here to IMPROVE a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null
        $rootScope.sessionSettings.newSupport.related = null
        VotingService.improve scope, clicked_proposal

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1

      it 'should check and FIND an existing vote from THIS user on THIS proposal', ->
        relatedSupport.proposal.id = 17
        scope.current_user_support = null
        VotingService.improve scope, clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        expect scope.current_user_support
          .toEqual 'related_proposal'

      it 'should check and FIND NO existing vote from THIS user on THIS proposal, then open modal', ->

        expect $rootScope.sessionSettings.openModals.improveProposal
          .toEqual false

        relatedSupport.proposal.id = 8
        VotingService.improve scope, clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        openModalArgs =
          templateUrl: 'proposals/_improve_proposal_modal.html'
          controller: 'ImproveCtrl'
          scope: scope

        expect $modal.open
          .toHaveBeenCalledWith openModalArgs
        expect modalInstance.opened.then
          .toHaveBeenCalled
        expect modalInstance.result.finally
          .toHaveBeenCalled
        expect $rootScope.sessionSettings.openModals.improveProposal
          .toEqual true

        modalInstance.result.finallyCallback()

        expect $rootScope.sessionSettings.openModals.improveProposal
          .toEqual false


    describe 'EDIT method should make checks and open EDIT modal', ->

      it 'should initialize EDIT method', ->
        VotingService.edit scope, clicked_proposal

        expect scope.clicked_proposal
          .toEqual clicked_proposal

      it 'should invoke sign-in warning if user manages to somehow get here to EDIT a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null
        VotingService.edit scope, clicked_proposal

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1

      it 'should open EDIT modal', ->

        expect $rootScope.sessionSettings.openModals.editProposal
          .toEqual false

        relatedSupport.proposal.id = 8
        VotingService.edit scope, clicked_proposal

        openModalArgs =
          templateUrl: 'proposals/_edit_proposal_modal.html'
          controller: 'EditProposalCtrl'
          scope: scope

        expect $modal.open
          .toHaveBeenCalledWith openModalArgs
        expect modalInstance.opened.then
          .toHaveBeenCalled
        expect modalInstance.result.finally
          .toHaveBeenCalled
        expect $rootScope.sessionSettings.openModals.editProposal
          .toEqual true

        modalInstance.result.finallyCallback()

        expect $rootScope.sessionSettings.openModals.editProposal
          .toEqual false


    describe 'DELETE method should make checks and open DELETE modal', ->

      it 'should initialize EDIT method', ->
        VotingService.delete scope, clicked_proposal

        expect scope.clicked_proposal
          .toEqual clicked_proposal

      it 'should invoke sign-in warning if user manages to somehow get here to DELETE a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null
        VotingService.edit scope, clicked_proposal

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1

      it 'should open DELETE modal', ->

        expect $rootScope.sessionSettings.openModals.deleteProposal
          .toEqual false

        relatedSupport.proposal.id = 8
        VotingService.delete scope, clicked_proposal

        openModalArgs =
          templateUrl: 'proposals/_delete_proposal_modal.html'
          controller: 'DeleteProposalCtrl'
          scope: scope

        expect $modal.open
          .toHaveBeenCalledWith openModalArgs
        expect modalInstance.opened.then
          .toHaveBeenCalled
        expect modalInstance.result.finally
          .toHaveBeenCalled
        expect $rootScope.sessionSettings.openModals.deleteProposal
          .toEqual true

        modalInstance.result.finallyCallback()

        expect $rootScope.sessionSettings.openModals.deleteProposal
          .toEqual false


    describe 'NEW method should make checks and open New Proposal modal', ->

      it 'should initialize NEW method by clearing alerts', ->
        VotingService.new()

        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1

      it 'should check for a current HUB and use it if it exists', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 3
          name: 'A sample group'

        VotingService.new()

        expect $rootScope.sessionSettings.actions.changeHub
          .toEqual false

      it 'should check for a current HUB and set CHANGE HUB if it does NOT exists', ->
        $rootScope.sessionSettings.hub_attributes = {}
        $rootScope.sessionSettings.actions.searchTerm = 'some recent search term'

        VotingService.new()

        expect $rootScope.sessionSettings.actions.changeHub
          .toEqual true
        expect $rootScope.sessionSettings.actions.searchTerm
          .toEqual null

      it 'should invoke sign-in warning if user manages to somehow get here to NEW a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null
        VotingService.new()

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1

      it 'should open NEW modal', ->

        expect $rootScope.sessionSettings.openModals.newProposal
          .toEqual false

        VotingService.new()

        openModalArgs =
          templateUrl: 'proposals/_new_proposal_modal.html'
          controller: 'NewProposalCtrl'

        expect $modal.open
          .toHaveBeenCalledWith openModalArgs
        expect modalInstance.opened.then
          .toHaveBeenCalled
        expect modalInstance.result.finally
          .toHaveBeenCalled
        expect $rootScope.sessionSettings.openModals.newProposal
          .toEqual true

        modalInstance.result.finallyCallback()

        expect $rootScope.sessionSettings.openModals.newProposal
          .toEqual false


    describe 'WIZARD method should make checks and open New Proposal Wizard modal', ->

      it 'should open WIZARD modal', ->

        expect $rootScope.sessionSettings.openModals.getStarted
          .toEqual false

        VotingService.wizard()

        openModalArgs =
          templateUrl: 'shared/_get_started_modal.html'
          controller: 'GetStartedCtrl'

        expect $modal.open
          .toHaveBeenCalledWith openModalArgs
        expect modalInstance.opened.then
          .toHaveBeenCalled
        expect modalInstance.result.finally
          .toHaveBeenCalled
        expect $rootScope.sessionSettings.openModals.getStarted
          .toEqual true

        modalInstance.result.finallyCallback()

        expect $rootScope.sessionSettings.openModals.getStarted
          .toEqual false



    describe 'CHANGHUB method should detect request and change to New Hub mode', ->

      it 'should not respond to a request with no args', ->

        $rootScope.sessionSettings.actions.newProposalHub = true
        $rootScope.sessionSettings.actions.changeHub = false

        VotingService.changeHub()

        expect $rootScope.sessionSettings.actions.newProposalHub
          .toEqual true
        expect $rootScope.sessionSettings.actions.changeHub
          .toEqual false

      it 'should  respond to a request with "true" arg', ->

        $rootScope.sessionSettings.actions.newProposalHub = true
        $rootScope.sessionSettings.actions.changeHub = false

        VotingService.changeHub true

        expect $rootScope.sessionSettings.actions.newProposalHub
          .toEqual null
        expect $rootScope.sessionSettings.actions.changeHub
          .toEqual true


    describe 'saveNewProposal method should SAVE New Proposal', ->

      it 'should check for NEW HUB and REJECT an invalid Hub Location if saving a New Hub', ->
        $rootScope.sessionSettings.hub_attributes.id = null
        $rootScope.sessionSettings.hub_attributes.formatted_location = null
        $rootScope.sessionSettings.openModals.newProposal = true

#        modalInstance:
#          result:
#            finallyCallback: ->
#              $rootScope.sessionSettings.openModals.newProposal = false

        spyOn Proposal, 'save'
          .and.returnValue status: 'Success'

        VotingService.saveNewProposal modalInstance

        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult
          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
          .toContain 'location appears to be invalid'
        expect Proposal.save
          .not.toHaveBeenCalled()

      it 'should check for NEW HUB and ACCEPT a valid Hub Location if saving a New Hub', ->
        $rootScope.sessionSettings.hub_attributes.id = null
        $rootScope.sessionSettings.hub_attributes.formatted_location = 'Atlanta, GA'
        $rootScope.sessionSettings.openModals.newProposal = true

#        modalInstance:
#          result:
#            finallyCallback: ->
#              $rootScope.sessionSettings.openModals.newProposal = false

        spyOn Proposal, 'save'
          .and.returnValue 'Success'

        VotingService.saveNewProposal modalInstance

        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 0

        expect Proposal.save
          .toHaveBeenCalled()

      it 'should check for a current HUB and use it if it exists', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 3
          name: 'A sample group'

        VotingService.new()

        expect $rootScope.sessionSettings.actions.changeHub
          .toEqual false

      it 'should check for a current HUB and set CHANGE HUB if it does NOT exists', ->
        $rootScope.sessionSettings.hub_attributes = {}
        $rootScope.sessionSettings.actions.searchTerm = 'some recent search term'

        VotingService.new()

        expect $rootScope.sessionSettings.actions.changeHub
          .toEqual true
        expect $rootScope.sessionSettings.actions.searchTerm
          .toEqual null

      it 'should invoke sign-in warning if user manages to somehow get here to NEW a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null
        VotingService.new()

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1

      it 'should open NEW modal', ->

        expect $rootScope.sessionSettings.openModals.newProposal
          .toEqual false

        VotingService.new()

        openModalArgs =
          templateUrl: 'proposals/_new_proposal_modal.html'
          controller: 'NewProposalCtrl'

        expect $modal.open
          .toHaveBeenCalledWith openModalArgs
        expect modalInstance.opened.then
          .toHaveBeenCalled
        expect modalInstance.result.finally
          .toHaveBeenCalled
        expect $rootScope.sessionSettings.openModals.newProposal
          .toEqual true

        modalInstance.result.finallyCallback()

        expect $rootScope.sessionSettings.openModals.newProposal
          .toEqual false
