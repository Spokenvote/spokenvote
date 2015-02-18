describe 'Voting Service Tests', ->
  beforeEach ->
    module 'spokenvote'

  describe 'VotingService should perform Voting Service tasks', ->
    $rootScope = undefined
    $httpBackend = undefined
    VotingService = undefined
    Proposal = undefined
    $location = undefined
    $modal = undefined
    modalInstance = undefined
    Focus = undefined
    scope = undefined
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

    beforeEach inject (_$rootScope_, _$httpBackend_, _VotingService_, _SessionSettings_, _$modal_, _$location_, _Proposal_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $modal = _$modal_
      $location = _$location_
      VotingService = _VotingService_
      Focus = jasmine.createSpy 'Focus'
      Proposal = _Proposal_
      $rootScope.sessionSettings = _SessionSettings_
      $rootScope.alertService =
        clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
        setInfo: jasmine.createSpy 'alertService:setInfo'
        setCtlResult: jasmine.createSpy 'alertService:setCtlResult'
        setSuccess: jasmine.createSpy 'alertService:setSuccess'
        setJson: jasmine.createSpy 'alertService:setJson'
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
        close: jasmine.createSpy 'modalInstance.close'

      spyOn $modal, 'open'
        .and.returnValue modalInstance

#      jasmine.createSpy 'Focus'

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

      it 'should check and FIND NO existing vote from THIS user on THIS proposal, then set values for voting', ->

#        expect $rootScope.sessionSettings.openModals.supportProposal
#          .toEqual false
        expect $rootScope.sessionSettings.newSupport.related.proposal
          .toEqual undefined

        relatedSupport.proposal.id = 8
        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

#        openModalArgs =
#          templateUrl: 'proposals/_support_modal.html'
#          controller: 'SupportCtrl'

        expect $rootScope.sessionSettings.newSupport.related.proposal
          .toBeDefined()
        expect $rootScope.sessionSettings.newSupport.related.proposal.id
          .toEqual 8
        expect $rootScope.sessionSettings.actions.newProposal.comment
          .toEqual true
#        expect Focus                                #Focus Spy is there, but does not seem to see it being called
#          .toHaveBeenCalledWith '#vote_comment'

#        expect $modal.open
#          .toHaveBeenCalledWith openModalArgs
#        expect modalInstance.opened.then
#          .toHaveBeenCalled()
#        expect modalInstance.result.finally
#          .toHaveBeenCalled()
#        expect $rootScope.sessionSettings.openModals.supportProposal
#          .toEqual true

#        modalInstance.result.finallyCallback()

#        expect $rootScope.sessionSettings.openModals.supportProposal
#          .toEqual false


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

#        expect $rootScope.sessionSettings.openModals.editProposal
#          .toEqual false

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

        expect $rootScope.sessionSettings.actions.newProposal.started
          .toEqual false

#        expect $rootScope.sessionSettings.actions.changeHub
#          .toEqual true
#        expect $rootScope.sessionSettings.actions.searchTerm
#          .toEqual null

      it 'should invoke sign-in warning if user manages to somehow get here to NEW a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null
#        VotingService.new()
#
#        expect $rootScope.alertService.setInfo.calls.count()
#          .toEqual 1

      it 'should invoke sign-in warning if user manages to somehow get here to NEW a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null
        VotingService.new()

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1

      it 'should invoke sign-in warning if user manages to somehow get here to NEW a proposal and is not signed in', ->
        VotingService.new()

#      it 'should open NEW modal', ->
      it 'should go to start NEW Proposal page', ->
        $rootScope.currentUser =
          id: 2

        VotingService.new()

        expect $location.url()
          .toEqual '/start'
#        openModalArgs =
#          templateUrl: 'proposals/_new_proposal_modal.html'
#          controller: 'NewProposalCtrl'

#        expect $modal.open
#          .toHaveBeenCalledWith openModalArgs
#        expect modalInstance.opened.then
#          .toHaveBeenCalled
#        expect modalInstance.result.finally
#          .toHaveBeenCalled
#        expect $rootScope.sessionSettings.openModals.newProposal
#          .toEqual true
#
#        modalInstance.result.finallyCallback()
#
#        expect $rootScope.sessionSettings.openModals.newProposal
#          .toEqual false


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
        $rootScope.sessionSettings.hub_attributes =
          id: null
          formatted_location: 'Atlanta, GA'
        $rootScope.sessionSettings.actions.searchTerm = 'New Group Name'
        $rootScope.sessionSettings.openModals.newProposal = true

        spyOn Proposal, 'save'
          .and.returnValue 'Success'

        VotingService.saveNewProposal modalInstance

        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 0
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 0
        expect Proposal.save
          .toHaveBeenCalled()

      it 'should check for EXISTING HUB, FIND one, and save the New Proposal', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12
          formatted_location: 'Atlanta, GA'

        $rootScope.sessionSettings.newProposal =
          statement: 'An awesome new proposal. Vote for it!'
          comment: 'A million reasons to vote for this guy!'

        $rootScope.sessionSettings.openModals.newProposal = true

        expectedProposalSaveArgs =
          proposal:
            statement: 'An awesome new proposal. Vote for it!'
            votes_attributes:
              comment: 'A million reasons to vote for this guy!'
            hub_id: 12
            hub_attributes:
              id: 12
              formatted_location: 'Atlanta, GA'

        spyOn Proposal, 'save'
          .and.returnValue 'Success'

        VotingService.saveNewProposal modalInstance

        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 0
        expect Proposal.save
          .toHaveBeenCalled()
        expect Proposal.save.calls.mostRecent().args[0]
          .toEqual expectedProposalSaveArgs

      it 'Proposal.save should save the New Proposal and execute correct SUCCESS callback', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12
        $rootScope.sessionSettings.openModals.newProposal = true

        response =
          id: 2045
          statement: 'An awesome new proposal. Vote for it!'

        spyOn Proposal, 'save'
          .and.returnValue status: 'Success'

#        VotingService.saveNewProposal modalInstance
        VotingService.saveNewProposal()
        Proposal.save.calls.mostRecent().args[1] response

        expect Proposal.save
          .toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function), jasmine.any(Function)
        expect $rootScope.alertService.setSuccess.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
          .toContain response.statement
#        expect $location.url()                               # TODO bug in Angular 1.29 that will be fixed with 1.3
#          .toEqual '/proposals/2045?filter=my#navigationBar'
#        expect modalInstance.close
#          .toHaveBeenCalledWith response
        expect $rootScope.sessionSettings.actions.offcanvas
          .toEqual false

      it 'Proposal.save should execute correct FAILURE callback', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12
        $rootScope.sessionSettings.openModals.newProposal = true

        response =
          data: 'There was a server error!'

        spyOn Proposal, 'save'
          .and.returnValue status: 'Error'

        VotingService.saveNewProposal modalInstance
        Proposal.save.calls.mostRecent().args[2] response

        expect Proposal.save
          .toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function), jasmine.any(Function)
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
          .toContain 'Sorry'
        expect $rootScope.alertService.setJson.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setJson.calls.mostRecent().args[0]
          .toContain response.data
