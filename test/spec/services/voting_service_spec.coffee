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
#    Focus = undefined
    scope = undefined
    clicked_proposal =
      id: 17
      statement: 'My proposal statement'
      votes: [
        id: 22
        comment: 'Why you should vote for this proposal']
    newProposal =
      id: 17
#      proposal:
      statement: 'My proposal statement'
      votes_attributes:
        id: 22
        comment: 'Why you should vote for this proposal'
    relatedSupport =
      id: 122
      comment: 'Have to give reason now ...'
      created_at: '2013-10-31 23:36:57 UTC'
      proposal:
        id: 8
        statement: 'Related proposal statement'
        hub:
          id: 1
          group_name: 'Hacker Dojo'
          formatted_location: 'Mountain View, CA'
    testTrash = 'Trash should should get killed'

    beforeEach inject (_$rootScope_, _$httpBackend_, _VotingService_, _SessionSettings_, _$modal_, _$location_, _Proposal_, _Focus_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $modal = _$modal_
      $location = _$location_
      VotingService = _VotingService_
#      stub.Focus = $injector.get 'Focus'
      Focus = _Focus_
      Proposal = _Proposal_
      $rootScope.sessionSettings = _SessionSettings_
      $rootScope.alertService =
        clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
        setInfo: jasmine.createSpy 'alertService:setInfo'
        setCtlResult: jasmine.createSpy 'alertService:setCtlResult'
        setSuccess: jasmine.createSpy 'alertService:setSuccess'
        setJson: jasmine.createSpy 'alertService:setJson'
      promise =
        then: (callback) ->
          $rootScope.currentUser =
            id: 5
          callback()
      $rootScope.authService =
        signinFb:
          jasmine
            .createSpy 'authService'
            .and.returnValue promise
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
#      spyOn Focus, 'Focus'

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

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
      expect VotingService.saveNewProposal
        .toBeDefined()


    describe 'SUPPORT method should make checks and open SUPPORT area', ->

      it 'should initialize Support method', ->

        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.sessionSettings.vote.target
          .toBe clicked_proposal
        expect $rootScope.sessionSettings.vote.related_existing
          .toBe undefined
        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1

      it 'should initialize support method with clean Session vote object', ->

        $rootScope.sessionSettings.vote.testTrash = 'Trash should should get killed'

        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.sessionSettings.vote.testTrash
          .toBe undefined

      it 'should invoke signinFb if user tries to SUPPORT a proposal and is not signed in', ->
        $rootScope.currentUser = {}

        expect  $rootScope.currentUser
          .toEqual { }

        VotingService.support clicked_proposal
        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.authService.signinFb.calls.count()
          .toEqual 1
        expect  $rootScope.currentUser
          .toEqual id: 5

      it 'should check and FIND an existing vote from THIS user on THIS proposal', ->
        relatedSupport.proposal.id = 17
        $rootScope.sessionSettings.vote.related_existing = null

        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setInfo
          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
        expect $rootScope.alertService.setInfo.calls.mostRecent().args[0]
          .toContain 'Good news, it looks as if you have already supported this proposal.'

      it 'should check and FIND related support, but NOT from this user on THIS proposal, then set values for voting', ->

        expect $rootScope.sessionSettings.vote.related_existing
          .toEqual undefined

        relatedSupport.proposal.id = 8
        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        expect $rootScope.sessionSettings.vote.target
          .toEqual clicked_proposal
        expect $rootScope.sessionSettings.vote.related_existing.proposal
          .toBeDefined()
        expect $rootScope.sessionSettings.vote.related_existing.proposal.id
          .toEqual 8
        expect $rootScope.alertService.setInfo.calls.mostRecent().args[0]
          .toContain 'We found support from you on another proposal.'

      it 'should check and find NO related support from this user on this proposal, then set values for voting', ->

        expect $rootScope.sessionSettings.vote.related_existing
          .toBeUndefined()

        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.sessionSettings.vote.target
          .toEqual clicked_proposal
        expect $rootScope.sessionSettings.vote.related_existing
          .toBeUndefined()

      it 'should open Support area', ->

        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        expect $rootScope.sessionSettings.vote.parent
          .toEqual undefined
        expect $rootScope.sessionSettings.vote.target
          .toEqual clicked_proposal


    describe 'IMPROVE method should make checks and open IMPROVE area', ->

      it 'should initialize IMPROVE method', ->

        VotingService.improve clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.sessionSettings.newProposal.parent_id
          .toEqual clicked_proposal.id
        expect $rootScope.sessionSettings.vote.related_existing
          .toEqual undefined
        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1

      it 'should initialize improve method with clean Session vote object', ->

        $rootScope.sessionSettings.vote.extraTrashObject = testTrash

        VotingService.improve clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.sessionSettings.vote.extraTrashObject
          .toBe undefined


      it 'should allow signed in Fb user to IMPROVE a proposal', ->
        $rootScope.currentUser =
          id: 5

        VotingService.improve clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.authService.signinFb.calls.any()
          .toBe false


      it 'should invoke signinFb if user tries to SUPPORT a proposal and is not signed in', ->
        $rootScope.currentUser = {}

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        VotingService.improve clicked_proposal

        $httpBackend.flush()

        expect $rootScope.authService.signinFb.calls.count()
          .toEqual 1

#      it 'should invoke sign-in warning if user manages to somehow get here to IMPROVE a proposal and is not signed in', ->
#        $rootScope.currentUser =
#          id: null
#        $rootScope.sessionSettings.vote.related_existing = null
#
#        VotingService.improve clicked_proposal
#
#        expect $rootScope.alertService.setInfo.calls.count()
#          .toEqual 1

      it 'should check and NOT find an existing vote from this user on this proposal', ->

        VotingService.improve clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 0

      it 'should check and FIND an existing vote from THIS user on THIS proposal', ->
        VotingService.improve clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setInfo
          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
        expect $rootScope.alertService.setInfo.calls.mostRecent().args[0]
          .toContain 'We found support from you on another proposal.'

      it 'should open Improve area', ->

        VotingService.improve clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        expect $rootScope.sessionSettings.newProposal.parent_id
          .toEqual clicked_proposal.id
        expect $rootScope.sessionSettings.vote.target
          .toEqual undefined


    describe 'EDIT method should make checks and open EDIT modal', ->

      it 'should initialize EDIT method', ->
        VotingService.edit clicked_proposal

        expect $rootScope.sessionSettings.newProposal
          .toEqual newProposal

      it 'should invoke sign-in warning if user manages to somehow get here to EDIT a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null

        VotingService.edit clicked_proposal

        expect $rootScope.authService.signinFb.calls.count()
          .toEqual 1
        expect  $rootScope.currentUser
          .toEqual id: 5

#      it 'should open EDIT modal', ->
#
##        expect $rootScope.sessionSettings.openModals.editProposal
##          .toEqual false
#
#        relatedSupport.proposal.id = 8
#        VotingService.edit scope, clicked_proposal
#
#        openModalArgs =
#          templateUrl: 'proposals/_edit_proposal_modal.html'
#          controller: 'EditProposalCtrl'
#          scope: scope
#
#        expect $modal.open
#          .toHaveBeenCalledWith openModalArgs
#        expect modalInstance.opened.then
#          .toHaveBeenCalled
#        expect modalInstance.result.finally
#          .toHaveBeenCalled
#        expect $rootScope.sessionSettings.openModals.editProposal
#          .toEqual true
#
#        modalInstance.result.finallyCallback()
#
#        expect $rootScope.sessionSettings.openModals.editProposal
#          .toEqual false


    describe 'DELETE method should make checks and open DELETE modal', ->

      it 'should initialize EDIT method', ->
        VotingService.delete scope, clicked_proposal

        expect scope.clicked_proposal
          .toEqual clicked_proposal

      it 'should invoke sign-in warning if user manages to somehow get here to DELETE a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null
        VotingService.delete scope, clicked_proposal

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


#    describe 'NEW method should make checks and open New Proposal modal', ->
#
#      it 'should initialize NEW method by clearing alerts', ->
#        VotingService.new()
#
#        expect $rootScope.alertService.clearAlerts.calls.count()
#          .toEqual 1
#
#      it 'should check for a current HUB and use it if it exists', ->
#        $rootScope.sessionSettings.hub_attributes =
#          id: 3
#          name: 'A sample group'
#
#        VotingService.new()
#
#        expect $rootScope.sessionSettings.actions.changeHub
#          .toEqual false

      it 'should check for a current HUB and set CHANGE HUB if it does NOT exists', ->
        $rootScope.sessionSettings.hub_attributes = null
#        $rootScope.sessionSettings.actions.hubCreate = 'some recent search term'

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

    describe 'COMMENT-STEP method should perform Comment Steps', ->
      Focus = jasmine.createSpy('Focus')

      ($provide) ->
        $provide.service "Focus", ->
          jasmine.createSpy('Focus').andCallFake () ->

      it 'should set Session Settings and Focus', ->

        VotingService.commentStep()

        expect $rootScope.sessionSettings.actions.focus
          .toEqual 'comment'
#        console.log 'Focus: ', Focus
#        expect Focus.calls.count()
#          .toEqual 1
#        expect Focus                   # TODO Don't get how to call this guy
#          .toHaveBeenCalled()

    describe 'WIZARD method should make checks and open New Proposal Wizard modal', ->

#      it 'should open WIZARD modal', ->
#
#        expect $rootScope.sessionSettings.openModals.getStarted
#          .toEqual false
#
#        VotingService.wizard()
#
#        openModalArgs =
#          templateUrl: 'shared/_get_started_modal.html'
#          controller: 'GetStartedCtrl'
#
#        expect $modal.open
#          .toHaveBeenCalledWith openModalArgs
#        expect modalInstance.opened.then
#          .toHaveBeenCalled
#        expect modalInstance.result.finally
#          .toHaveBeenCalled
#        expect $rootScope.sessionSettings.openModals.getStarted
#          .toEqual true
#
#        modalInstance.result.finallyCallback()
#
#        expect $rootScope.sessionSettings.openModals.getStarted
#          .toEqual false


#    describe 'CHANGHUB method should detect request and change to New Hub mode', ->
#
#      it 'should not respond to a request with no args', ->
#
#        $rootScope.sessionSettings.actions.newProposalHub = true
#        $rootScope.sessionSettings.actions.changeHub = false
#
#        VotingService.changeHub()
#
#        expect $rootScope.sessionSettings.actions.newProposalHub
#          .toEqual true
#        expect $rootScope.sessionSettings.actions.changeHub
#          .toEqual false
#
#      it 'should  respond to a request with "true" arg', ->
#
#        $rootScope.sessionSettings.actions.newProposalHub = true
#        $rootScope.sessionSettings.actions.changeHub = false
#
#        VotingService.changeHub true
#
#        expect $rootScope.sessionSettings.actions.newProposalHub
#          .toEqual null
#        expect $rootScope.sessionSettings.actions.changeHub
#          .toEqual true

    describe 'saveNewProposal method should SAVE New Proposal', ->
#Jul 2, 2015
#
#      it 'should check for NEW HUB and REJECT an invalid Hub LOCATION if saving a New Hub', ->
#        $rootScope.sessionSettings.hub_attributes =
#          id: null
#          group_name: 'Some Wonderful Hub Name'
#          formatted_location: null
#
#        spyOn Proposal, 'save'
#
#        VotingService.saveNewProposal()
#
#        expect $rootScope.alertService.clearAlerts.calls.count()
#          .toEqual 1
#        expect $rootScope.alertService.setCtlResult.calls.count()
#          .toEqual 1
#        expect $rootScope.alertService.setCtlResult
#          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
#        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
#          .toContain 'location appears to be invalid'
#        expect Proposal.save
#          .not.toHaveBeenCalled()

#      it 'should check for NEW HUB and REJECT a MISSING Hub NAME if saving a New Hub', ->
#        $rootScope.sessionSettings.hub_attributes =
#          id: null
#          group_name: null
#          formatted_location: 'Atlanta, GA'
#
#        spyOn Proposal, 'save'
#
#        VotingService.saveNewProposal()
#
#        expect $rootScope.alertService.clearAlerts.calls.count()
#          .toEqual 1
#        expect $rootScope.alertService.setCtlResult.calls.count()
#          .toEqual 1
#        expect $rootScope.alertService.setCtlResult
#          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
#        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
#          .toContain 'name appears to be missing'
#        expect Proposal.save
#          .not.toHaveBeenCalled()

#      it 'should check for NEW HUB and REJECT a TOO-SHORT Hub NAME if saving a New Hub', ->
#        $rootScope.sessionSettings.hub_attributes =
#          id: null
#          group_name: 'Da'
#          formatted_location: 'Atlanta, GA'
#
#        spyOn Proposal, 'save'
#
#        VotingService.saveNewProposal()
#
#        expect $rootScope.alertService.clearAlerts.calls.count()
#          .toEqual 1
#        expect $rootScope.alertService.setCtlResult.calls.count()
#          .toEqual 1
#        expect $rootScope.alertService.setCtlResult
#          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
#        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
#          .toContain 'name appears to be invalid'
#        expect Proposal.save
#          .not.toHaveBeenCalled()

      it 'should check for NEW HUB and ACCEPT a valid Hub Location if saving a New Hub', ->
        $rootScope.sessionSettings.hub_attributes =
          id: null
          group_name: 'Some very fine Group Name'
          formatted_location: 'Atlanta, GA'
#        $rootScope.sessionSettings.actions.hubCreate = 'New Group Name'
#        $rootScope.sessionSettings.openModals.newProposal = true

        $rootScope.sessionSettings.newProposal =
          statement: 'An awesome new proposal. Vote for it!'

        spyOn Proposal, 'save'

        VotingService.saveNewProposal()

        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 0
        expect Proposal.save
          .toHaveBeenCalled()

      it 'should check for EXISTING HUB, FIND one, and pass correct args to the SAVE New Proposal', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12
          group_name: 'Some very fine Group Name'
          formatted_location: 'Atlanta, GA'

        $rootScope.sessionSettings.newProposal =
          statement: 'An awesome new proposal. Vote for it!'
          votes_attributes:
            comment: 'A million reasons to vote for this guy!'

        expectedProposalSaveArgs =
          proposal:
            statement: 'An awesome new proposal. Vote for it!'
            votes_attributes:
              comment: 'A million reasons to vote for this guy!'
            hub_id: 12
            hub_attributes:
              id: 12
              group_name: 'Some very fine Group Name'
              formatted_location: 'Atlanta, GA'

        spyOn Proposal, 'save'
          .and.callThrough()

        VotingService.saveNewProposal()

        $httpBackend
          .expectPOST '/proposals'
          .respond relatedSupport

        $httpBackend.flush()

        expect Proposal.save
          .toHaveBeenCalled()
        expect Proposal.save.calls.mostRecent().args[0]
          .toEqual expectedProposalSaveArgs

      it 'should check for exiting hub, find one, and POST the New Proposal', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12
          group_name: 'Some very fine Group Name'
          formatted_location: 'Atlanta, GA'

        $rootScope.sessionSettings.newProposal =
          statement: 'An awesome new proposal. Vote for it!'
          comment: 'A million reasons to vote for this guy!'

        VotingService.saveNewProposal()

        $httpBackend
          .expectPOST '/proposals'
          .respond 201

        $httpBackend.flush()

      it 'should check for exiting hub, find one, save and ALERT the New Proposal was saved', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12
          group_name: 'Some very fine Group Name'
          formatted_location: 'Atlanta, GA'

        $rootScope.sessionSettings.newProposal =
          statement: 'An awesome new proposal. Vote for it!'
          comment: 'A million reasons to vote for this guy!'

        VotingService.saveNewProposal()

        $httpBackend
          .expectPOST '/proposals'
          .respond 201

        $httpBackend.flush()

        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 0
        expect $rootScope.alertService.setSuccess.calls.count()
          .toEqual 1

      it 'should allow COMMENTLESS VOTING and save New Proposal with undefined comment', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12
          group_name: 'Some very fine Group Name'
          formatted_location: 'Atlanta, GA'

        $rootScope.sessionSettings.newProposal =
          statement: 'An awesome new proposal. Vote for it!'
          votes_attributes:
            comment: undefined

        VotingService.saveNewProposal()

        $httpBackend
          .expectPOST '/proposals'
          .respond 201

        $httpBackend.flush()

#        expect $rootScope.sessionSettings.newProposal.votes_attributes.comment
#          .toBeUndefined     # changed logic Jul 2, 2015
        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 0
        expect $rootScope.alertService.setSuccess.calls.count()
          .toEqual 1

      it 'Proposal.save should save the New Proposal and execute correct SUCCESS callback', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12

        $rootScope.sessionSettings.newProposal =
          statement: 'An awesome new proposal. Vote for it!'

        response =
          id: 2045
          statement: 'An awesome new proposal. Vote for it!'
          comment: 'A million reasons to vote for this guy!'

        spyOn Proposal, 'save'
          .and.callThrough()

        VotingService.saveNewProposal()

        $httpBackend
          .expectPOST '/proposals'
          .respond 201, response

        $httpBackend.flush()

        expect Proposal.save
          .toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function), jasmine.any(Function)
        expect $rootScope.alertService.setSuccess.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
          .toContain response.statement
        expect $rootScope.sessionSettings.actions.offcanvas
          .toEqual false

      it 'Proposal.save should save the New Proposal and navigate to the correct LOCATION', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12

        $rootScope.sessionSettings.newProposal =
          statement: 'An awesome new proposal. Vote for it!'

        response =
          id: 2045
          statement: 'An awesome new proposal. Vote for it!'
          comment: 'A million reasons to vote for this guy!'

        VotingService.saveNewProposal()

        $httpBackend
          .expectPOST '/proposals'
          .respond 201, response

        $httpBackend.flush()

#        expect $location.url()                               # TODO bug in Angular 1.29 that should now be fixed with 1.3
#          .toEqual '/proposals/2045?filter=my'
        expect $location.url()                               # TODO bug in Angular 1.29 that should now be fixed with 1.3
          .toEqual '/proposals/2045?filter=my#navigationBar'

      it 'Proposal.save should execute correct FAILURE callback and ALERTS', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12

        $rootScope.sessionSettings.newProposal =
          statement: 'An awesome new proposal. Vote for it!'

        response =
          data: 'There was a server error!'

        spyOn Proposal, 'save'
          .and.callThrough()

        VotingService.saveNewProposal()

        $httpBackend
          .expectPOST '/proposals'
          .respond 422, response

        $httpBackend.flush()

        expect Proposal.save
          .toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function), jasmine.any(Function)
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
          .toContain 'Sorry'
        expect $rootScope.alertService.setJson.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setJson.calls.mostRecent().args[0]
          .toEqual response
