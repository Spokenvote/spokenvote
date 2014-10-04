describe 'Voting Service Tests', ->
  beforeEach ->
    module 'spokenvote'

  describe 'VotingService should perform Voting Service tasks', ->
    $rootScope = undefined
    $httpBackend = undefined
    VotingService = undefined
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

    beforeEach inject (_$rootScope_, _$httpBackend_, _VotingService_, _SessionSettings_, _$modal_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $modal = _$modal_
#      $modal =
#        open: jasmine.createSpy 'modal:setCtlResult'
      VotingService = _VotingService_
#      $location = _$location_
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
        SupportCtrl = jasmine.createSpy('SupportCtrl')
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
        VotingService.improve scope, clicked_proposal

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1

      it 'should check and FIND an existing vote from THIS user on THIS proposal', ->
        relatedSupport.proposal.id = 17
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
        SupportCtrl = jasmine.createSpy('SupportCtrl')
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
