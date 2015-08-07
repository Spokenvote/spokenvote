describe 'Voting Service Tests', ->
  beforeEach ->
    module 'spokenvote'

  describe 'VotingService should perform Voting Service tasks', ->
    $rootScope = undefined
    $httpBackend = undefined
    VotingService = undefined
    Proposal = undefined
    Vote = undefined
    $location = undefined
    $modal = undefined
    modalInstance = undefined
    svUtility = undefined
    scope = undefined
    clicked_proposal =
      id: 17
      statement: 'My proposal statement'
      votes: [
        id: 22
        comment: 'Why you should vote for this proposal']
    newProposal =
      id: 17
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

    beforeEach inject (_$rootScope_, _$httpBackend_, _VotingService_, _SessionSettings_, _$modal_, _$location_, _Proposal_, _Vote_, _svUtility_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $modal = _$modal_
      $location = _$location_
      VotingService = _VotingService_
      svUtility = _svUtility_
      Proposal = _Proposal_
      Vote = _Vote_
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
      spyOn svUtility, 'focus'
        .and.callThrough()
      spyOn $rootScope, '$broadcast'
        .and.callThrough()

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it 'should initialize methods', ->
      expect VotingService.new
        .toBeDefined()
      expect VotingService.support
        .toBeDefined()
      expect VotingService.improve
        .toBeDefined()
      expect VotingService.edit
        .toBeDefined()
      expect VotingService.delete
        .toBeDefined()
      expect VotingService.commentStep
        .toBeDefined()
      expect VotingService.hubStep
        .toBeDefined()
      expect VotingService.saveVote
        .toBeDefined()


    describe 'NEW method should make checks and open NEW Proposal area', ->

      it 'should initialize New method', ->

        VotingService.new()

        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $rootScope.sessionSettings.actions.newVoteDetails.proposalStarted
          .toEqual false

      it 'should invoke sign-in warning if user manages to somehow get here to NEW a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null

        VotingService.new()

        expect $rootScope.alertService.setInfo.calls.count()
          .toEqual 1

      it 'should see signed-in user and to to Start page', ->

        VotingService.new()

      it 'should go to start NEW Proposal page', ->
        $rootScope.currentUser =
          id: 2

        VotingService.new()

        expect $location.url()
          .toEqual '/start'


    describe 'SUPPORT method should make checks and open SUPPORT area', ->

      it 'should initialize Support method', ->

        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.sessionSettings.newVote.votes_attributes.proposal_id
          .toBe clicked_proposal.id
        expect $rootScope.sessionSettings.actions.newVoteDetails.related_existing
          .toBe undefined
        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1

      it 'should initialize support method with clean Session vote object', ->

        $rootScope.sessionSettings.newVote.testTrash = 'Trash should should get killed'

        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.sessionSettings.newVote.testTrash
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
        $rootScope.sessionSettings.actions.newVoteDetails.related_existing = null

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

        expect $rootScope.sessionSettings.actions.newVoteDetails.related_existing
          .toEqual undefined

        relatedSupport.proposal.id = 8
        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        expect $rootScope.sessionSettings.newVote.votes_attributes.proposal_id
          .toBe clicked_proposal.id
        expect $rootScope.sessionSettings.actions.newVoteDetails.related_existing.proposal
          .toBeDefined()
        expect $rootScope.sessionSettings.actions.newVoteDetails.related_existing.proposal.id
          .toEqual 8
        expect $rootScope.alertService.setInfo.calls.mostRecent().args[0]
          .toContain 'We found support from you on another proposal.'

      it 'should check and find NO related support from this user on this proposal, then set values for voting', ->

        expect $rootScope.sessionSettings.actions.newVoteDetails.related_existing
          .toBeUndefined()

        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.sessionSettings.newVote.votes_attributes.proposal_id
          .toBe clicked_proposal.id
        expect $rootScope.sessionSettings.actions.newVoteDetails.related_existing
          .toBeUndefined()

      it 'should open Support area', ->

        VotingService.support clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond relatedSupport

        $httpBackend.flush()

        expect $rootScope.sessionSettings.actions.newVoteDetails.parent
          .toEqual undefined
        expect $rootScope.sessionSettings.newVote.votes_attributes.proposal_id
          .toBe clicked_proposal.id
        expect $rootScope.sessionSettings.actions.focus
          .toEqual 'comment'


    describe 'IMPROVE method should make checks and open IMPROVE area', ->

      it 'should initialize IMPROVE method', ->

        VotingService.improve clicked_proposal

        $httpBackend
          .expectGET '/proposals/17/related_vote_in_tree'
          .respond null

        $httpBackend.flush()

        expect $rootScope.sessionSettings.newVote.parent_id
          .toEqual clicked_proposal.id
        expect $rootScope.sessionSettings.actions.newVoteDetails.related_existing
          .toEqual undefined
        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1

#      it 'should initialize improve method with clean Session vote object', ->
#
#        $rootScope.sessionSettings.actions.newVoteDetails.extraTrashObject = testTrash
#
#        VotingService.improve clicked_proposal
#
#        $httpBackend
#          .expectGET '/proposals/17/related_vote_in_tree'
#          .respond null
#
#        $httpBackend.flush()
#
#        expect $rootScope.sessionSettings.actions.newVoteDetails.extraTrashObject
#          .toBe undefined

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

        expect $rootScope.sessionSettings.newVote.parent_id
          .toEqual clicked_proposal.id
        expect $rootScope.sessionSettings.actions.newVoteDetails.target
          .toEqual undefined


    describe 'EDIT method should make checks and open EDIT modal', ->

      it 'should initialize EDIT method', ->
        VotingService.edit clicked_proposal

        expect $rootScope.sessionSettings.newVote
          .toEqual newProposal

      it 'should invoke sign-in warning if user manages to somehow get here to EDIT a proposal and is not signed in', ->
        $rootScope.currentUser =
          id: null

        VotingService.edit clicked_proposal

        expect $rootScope.authService.signinFb.calls.count()
          .toEqual 1
        expect  $rootScope.currentUser
          .toEqual id: 5


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


    describe 'COMMENT-STEP method should perform Comment Steps', ->

      it 'should set Session Settings and Focus', ->

        VotingService.commentStep()

        expect $rootScope.sessionSettings.actions.focus
          .toEqual 'comment'
        expect svUtility.focus.calls.count()
          .toEqual 1


    describe 'HUB-STEP method should perform Hub Steps', ->

      it 'should set Session Settings', ->

        VotingService.hubStep()

        expect $rootScope.sessionSettings.actions.focus
          .toEqual 'hub'
        expect $rootScope.sessionSettings.actions.hubShow
          .toEqual true

      it 'should check for and FIND Hub and newProposal statement', ->

        $rootScope.sessionSettings.hub_attributes =
          full_hub:'Some great hub'
        $rootScope.sessionSettings.newVote =
          statement: 'An awesome new proposal. Vote for it!'

        spyOn VotingService, 'commentStep'
          .and.callThrough()

        VotingService.hubStep()

        expect VotingService.commentStep
          .toHaveBeenCalled
        expect $rootScope.sessionSettings.actions.focus
          .toEqual 'comment'
        expect $rootScope.sessionSettings.actions.hubShow
          .toEqual true
        expect svUtility.focus.calls.count()
          .toEqual 1

      it 'should check for and detect MISSING Hub statement', ->

        $rootScope.sessionSettings.hub_attributes =
          full_hub:'Some great hub'
        $rootScope.sessionSettings.newVote = {}

        spyOn VotingService, 'commentStep'
          .and.callThrough()

        VotingService.hubStep()

        expect VotingService.commentStep
          .toHaveBeenCalled
        expect $rootScope.sessionSettings.actions.focus
          .toEqual 'hub'
        expect $rootScope.sessionSettings.actions.hubShow
          .toEqual true
        expect svUtility.focus.calls.count()
          .toEqual 0
        expect $rootScope.alertService.setCtlResult.calls.count()
          .toEqual 1
        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
          .toContain 'Sorry'

      it 'should check for and detect MISSING newProposal statement', ->

        $rootScope.sessionSettings.hub_attributes = null
        $rootScope.sessionSettings.newVote =
          statement: 'An awesome new proposal. Vote for it!'

        spyOn VotingService, 'commentStep'
          .and.callThrough()

        VotingService.hubStep()

        expect VotingService.commentStep
          .toHaveBeenCalled
        expect $rootScope.sessionSettings.actions.focus
          .toEqual 'hub'
        expect $rootScope.sessionSettings.actions.hubShow
          .toEqual true
        expect svUtility.focus.calls.count()
          .toEqual 0
        expect $rootScope.$broadcast
          .toHaveBeenCalledWith 'focusHubFilter'


    describe 'saveVote method should SAVE New Vote', ->

      it 'should clear alerts', ->
        $rootScope.sessionSettings.newVote = newProposal

        $rootScope.sessionSettings.hub_attributes =
          id: null
          group_name: 'Some very fine Group Name'
          formatted_location: 'Atlanta, GA'

        spyOn Proposal, 'save'
        spyOn Proposal, 'update'
        spyOn Vote, 'save'

        VotingService.saveVote()

        expect $rootScope.alertService.clearAlerts.calls.count()
          .toEqual 1

      it 'Proposal.save should execute correct FAILURE callback and ALERTS', ->
        $rootScope.sessionSettings.hub_attributes =
          id: 12

        $rootScope.sessionSettings.newVote =
          statement: 'An awesome new proposal. Vote for it!'

        response =
          data: 'There was a server error!'

        spyOn Proposal, 'save'
          .and.callThrough()

        VotingService.saveVote()

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


      describe 'should save NEW PROPOSAL along with vote', ->

        it 'should check for a INVALID Proposal STATEMENT and throw error', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An'
          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'
          spyOn Vote, 'save'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 1
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect Vote.save
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual 'comment'

        it 'should check for a INVALID Vote COMMENT and throw error', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote.votes_attributes =
            proposal_id: 123
            comment: 'An'
          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'
          spyOn Vote, 'save'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 1
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect Vote.save
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual 'comment'

        it 'should check for NEW HUB and ACCEPT a valid Hub Location if saving a New Hub', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 0
          expect Proposal.save
            .toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
#          expect $rootScope.sessionSettings.actions.focus
#            .toEqual null

        it 'should check for NEW HUB and REJECT in invalid Hub Location if saving a New Hub', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'Some very fine Group Name'
            formatted_location: null

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
            .toContain 'Sorry'
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual 'comment'

        it 'should check for NEW HUB and REJECT in invalid Group Name if saving a New Hub', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: null
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
            .toContain 'Sorry'
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual 'comment'

        it 'should check for NEW HUB and REJECT in Group Name that is TOO SHORT if saving a New Hub', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'ma'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
            .toContain 'Sorry'
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual 'comment'

        it 'should check for EXISTING HUB, FIND one, and pass correct args to the SAVE New Proposal', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 12
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
            votes_attributes:
              comment: 'A million reasons to vote for this guy!'

          expectedProposalSaveArgs =
            proposal:
              statement: 'An awesome new proposal. Vote for it!'
              votes_attributes:
                comment: 'A million reasons to vote for this guy!'
              hub_id: 12
#              hub_attributes:
#                id: 12
#                group_name: 'Some very fine Group Name'
#                formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
            .and.callThrough()
          spyOn Proposal, 'update'

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/proposals'
            .respond relatedSupport

          $httpBackend.flush()

          expect Proposal.save
            .toHaveBeenCalled()
          expect Proposal.save.calls.mostRecent().args[0]
            .toEqual expectedProposalSaveArgs
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual null

        it 'should check for GOOGLE LOCATION HUB, and pass correct args to the SAVE New Proposal', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 'GL-12'
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
            votes_attributes:
              comment: 'A million reasons to vote for this guy!'

          expectedProposalSaveArgs =
            proposal:
              statement: 'An awesome new proposal. Vote for it!'
              votes_attributes:
                comment: 'A million reasons to vote for this guy!'
              hub_attributes:
                id: 'GL-12'
                group_name: 'Some very fine Group Name'
                formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
            .and.callThrough()
          spyOn Proposal, 'update'
          spyOn Vote, 'save'

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/proposals'
            .respond relatedSupport

          $httpBackend.flush()

          expect Proposal.save
            .toHaveBeenCalled()
          expect Proposal.save.calls.mostRecent().args[0]
            .toEqual expectedProposalSaveArgs
          expect Vote.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual null

        it 'should check for exiting hub, find one, and POST the New Proposal', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 12
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
            comment: 'A million reasons to vote for this guy!'

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/proposals'
            .respond 201

          $httpBackend.flush()

        it 'should check for exiting hub, find one, save and ALERT the New Proposal was saved', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 12
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
            comment: 'A million reasons to vote for this guy!'

          VotingService.saveVote()

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

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
            votes_attributes:
              comment: undefined

          VotingService.saveVote()

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

        it 'Proposal.save should save the New Proposal and execute correct SUCCESS callback', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 12

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'

          response =
            id: 2045
            statement: 'An awesome new proposal. Vote for it!'
            comment: 'A million reasons to vote for this guy!'

          spyOn Proposal, 'save'
            .and.callThrough()

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/proposals'
            .respond 201, response

          $httpBackend.flush()

          expect Proposal.save
            .toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function), jasmine.any(Function)
          expect $rootScope.$broadcast
            .toHaveBeenCalledWith 'event:proposalsChanged'
          expect $rootScope.$broadcast
            .toHaveBeenCalledWith 'event:votesChanged'
          expect $rootScope.alertService.setSuccess.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
            .toContain 'has been saved'
          expect $rootScope.sessionSettings.actions.offcanvas
            .toEqual false
          expect $rootScope.sessionSettings.newVote
            .toEqual {}


        it 'Proposal.save should save the New Proposal and navigate to the correct LOCATION', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 12

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'

          response =
            id: 2045
            statement: 'An awesome new proposal. Vote for it!'
            comment: 'A million reasons to vote for this guy!'

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/proposals'
            .respond 201, response

          $httpBackend.flush()

          expect $location.url()
            .toEqual '/proposals/2045?filter=my#navigationBar'


      describe 'should save FORK PROPOSAL along with vote', ->

        it 'should check for a INVALID Proposal STATEMENT and throw error', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            parent_id: 445
            statement: 'An'

          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'
          spyOn Vote, 'save'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 1
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect Vote.save
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual 'comment'

        it 'should check for a INVALID Vote COMMENT and throw error', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            parent_id: 445
            statement: 'An awesome new proposal. Vote for it!'
            votes_attributes:
              proposal_id: 123
              comment: 'An'

          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'
          spyOn Vote, 'save'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 1
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect Vote.save
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual 'comment'

        it 'should ACCEPT Proposal without a Hub Location when saving a FORK', ->
          $rootScope.sessionSettings.hub_attributes = null
#            id: null
#            group_name: 'Some very fine Group Name'
#            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            parent_id: 445
            statement: 'An awesome new proposal. Vote for it!'

          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 0
          expect Proposal.save
            .toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
#          expect $rootScope.sessionSettings.actions.focus
#            .toEqual null

        it 'should check for NEW HUB and REJECT in invalid Hub Location if saving a New Hub', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'Some very fine Group Name'
            formatted_location: null

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
            .toContain 'Sorry'
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual 'comment'

        it 'should check for NEW HUB and REJECT in invalid Group Name if saving a New Hub', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: null
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
            .toContain 'Sorry'
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual 'comment'

        it 'should check for NEW HUB and REJECT in Group Name that is TOO SHORT if saving a New Hub', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'ma'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
            .toContain 'Sorry'
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual 'comment'

        it 'should check for EXISTING HUB, FIND one, and pass correct args to the SAVE New Proposal', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 12
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
            votes_attributes:
              comment: 'A million reasons to vote for this guy!'

          expectedProposalSaveArgs =
            proposal:
              statement: 'An awesome new proposal. Vote for it!'
              votes_attributes:
                comment: 'A million reasons to vote for this guy!'
              hub_id: 12
#              hub_attributes:
#                id: 12
#                group_name: 'Some very fine Group Name'
#                formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
            .and.callThrough()
          spyOn Proposal, 'update'

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/proposals'
            .respond relatedSupport

          $httpBackend.flush()

          expect Proposal.save
            .toHaveBeenCalled()
          expect Proposal.save.calls.mostRecent().args[0]
            .toEqual expectedProposalSaveArgs
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual null

        it 'should check for GOOGLE LOCATION HUB, and pass correct args to the SAVE New Proposal', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 'GL-12'
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
            votes_attributes:
              comment: 'A million reasons to vote for this guy!'

          expectedProposalSaveArgs =
            proposal:
              statement: 'An awesome new proposal. Vote for it!'
              votes_attributes:
                comment: 'A million reasons to vote for this guy!'
              hub_attributes:
                id: 'GL-12'
                group_name: 'Some very fine Group Name'
                formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
            .and.callThrough()
          spyOn Proposal, 'update'
          spyOn Vote, 'save'

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/proposals'
            .respond relatedSupport

          $httpBackend.flush()

          expect Proposal.save
            .toHaveBeenCalled()
          expect Proposal.save.calls.mostRecent().args[0]
            .toEqual expectedProposalSaveArgs
          expect Vote.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect $rootScope.sessionSettings.actions.focus
            .toEqual null

        it 'should check for exiting hub, find one, and POST the New Proposal', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 12
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
            comment: 'A million reasons to vote for this guy!'

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/proposals'
            .respond 201

          $httpBackend.flush()

        it 'should check for exiting hub, find one, save and ALERT the New Proposal was saved', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 12
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
            comment: 'A million reasons to vote for this guy!'

          VotingService.saveVote()

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

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'
            votes_attributes:
              comment: undefined

          VotingService.saveVote()

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

        it 'Proposal.save should save the New Proposal and execute correct SUCCESS callback', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 12

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'

          response =
            id: 2045
            statement: 'An awesome new proposal. Vote for it!'
            comment: 'A million reasons to vote for this guy!'

          spyOn Proposal, 'save'
            .and.callThrough()

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/proposals'
            .respond 201, response

          $httpBackend.flush()

          expect Proposal.save
            .toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function), jasmine.any(Function)
          expect $rootScope.$broadcast
            .toHaveBeenCalledWith 'event:proposalsChanged'
          expect $rootScope.$broadcast
            .toHaveBeenCalledWith 'event:votesChanged'
          expect $rootScope.alertService.setSuccess.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
            .toContain 'has been saved'
          expect $rootScope.sessionSettings.actions.offcanvas
            .toEqual false
          expect $rootScope.sessionSettings.newVote
            .toEqual {}


        it 'Proposal.save should save the New Proposal and navigate to the correct LOCATION', ->
          $rootScope.sessionSettings.hub_attributes =
            id: 12

          $rootScope.sessionSettings.newVote =
            statement: 'An awesome new proposal. Vote for it!'

          response =
            id: 2045
            statement: 'An awesome new proposal. Vote for it!'
            comment: 'A million reasons to vote for this guy!'

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/proposals'
            .respond 201, response

          $httpBackend.flush()

          expect $location.url()
            .toEqual '/proposals/2045?filter=my#navigationBar'


      describe 'saveVote method should UPDATE PROPOSAL and Vote', ->

        it 'should check for Proposal UPDATING and set newProposal.id flag for Update', ->

          $rootScope.sessionSettings.newVote = newProposal

#          $rootScope.sessionSettings.newVote = newProposal
#            id: newProposal.id
#            statement: newProposal.statement
#            votes_attributes:
#              comment: newProposal.votes_attributes.comment

          newProposalParams =
            id: newProposal.id
            proposal: newProposal

          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'
          spyOn Vote, 'save'

          VotingService.saveVote()

          expect Proposal.update
           .toHaveBeenCalledWith newProposalParams, jasmine.any(Function), jasmine.any(Function)
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Vote.save
            .not.toHaveBeenCalled()
#          expect $rootScope.sessionSettings.actions.focus
#            .toEqual null


      describe 'saveVote method should save VOTE only to Support a proposal', ->

        it 'should check for and find a VALID Vote COMMENT and save vote', ->
          $rootScope.sessionSettings.hub_attributes =
            id: null
            group_name: 'Some very fine Group Name'
            formatted_location: 'Atlanta, GA'

          $rootScope.sessionSettings.newVote.votes_attributes =
            proposal_id: 123
            comment: 'Nice long vote comment'
          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'
          spyOn Vote, 'save'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 0
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect Vote.save
            .toHaveBeenCalled()
#          expect $rootScope.sessionSettings.actions.focus
#            .toEqual null

        it 'should check for NO Vote COMMENT and save vote', ->

          $rootScope.sessionSettings.newVote.votes_attributes =
            proposal_id: 123

          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'
          spyOn Vote, 'save'

          VotingService.saveVote()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 0
          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect Vote.save
            .toHaveBeenCalled()
#          expect $rootScope.sessionSettings.actions.focus
#            .toEqual null

        it 'should pass correct args to the SAVE New Vote', ->
          $rootScope.sessionSettings.newVote.votes_attributes =
            proposal_id: 123

          $rootScope.sessionSettings.actions.focus = 'comment'

          spyOn Proposal, 'save'
          spyOn Proposal, 'update'
          spyOn Vote, 'save'
            .and.callThrough()

          expectedProposalSaveArgs =
            proposal_id: 123

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/votes'
            .respond relatedSupport

          $httpBackend.flush()

          expect Proposal.save
            .not.toHaveBeenCalled()
          expect Proposal.update
            .not.toHaveBeenCalled()
          expect Vote.save
            .toHaveBeenCalled()
          expect Vote.save.calls.mostRecent().args[0]
            .toEqual expectedProposalSaveArgs
          expect $rootScope.sessionSettings.actions.focus
            .toEqual null

        it 'should POST and respond with 201', ->
          $rootScope.sessionSettings.newVote.votes_attributes =
            proposal_id: 123

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/votes'
            .respond 201

          $httpBackend.flush()

        it 'ALERT the New Vote was saved', ->
          $rootScope.sessionSettings.newVote.votes_attributes =
            proposal_id: 123

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/votes'
            .respond 201

          $httpBackend.flush()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 0
          expect $rootScope.alertService.setSuccess.calls.count()
            .toEqual 1
          expect $rootScope.sessionSettings.actions.focus
            .toEqual null

        it 'should allow COMMENTLESS VOTING and save New Vote with undefined comment', ->
          $rootScope.sessionSettings.newVote.votes_attributes =
            proposal_id: 123

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/votes'
            .respond 201

          $httpBackend.flush()

          expect $rootScope.alertService.clearAlerts.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setCtlResult.calls.count()
            .toEqual 0
          expect $rootScope.alertService.setSuccess.calls.count()
            .toEqual 1
          expect $rootScope.sessionSettings.actions.focus
            .toEqual null

        it 'save the New Vote and execute correct SUCCESS callback', ->
          $rootScope.sessionSettings.newVote.votes_attributes =
            proposal_id: 123

          response =
            proposal_id: 627
            comment: 'A million reasons to vote for this guy!'

          spyOn Vote, 'save'
            .and.callThrough()

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/votes'
            .respond 201, response

          $httpBackend.flush()

          expect Vote.save
            .toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function), jasmine.any(Function)
          expect $rootScope.$broadcast
            .toHaveBeenCalledWith 'event:proposalsChanged'
          expect $rootScope.$broadcast
            .toHaveBeenCalledWith 'event:votesChanged'
          expect $rootScope.alertService.setSuccess.calls.count()
            .toEqual 1
          expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
            .toContain 'has been saved'
          expect $rootScope.sessionSettings.actions.offcanvas
            .toEqual false
          expect $rootScope.sessionSettings.newVote
            .toEqual {}

        it 'should save the New Vote and navigate to the correct LOCATION', ->
          $rootScope.sessionSettings.newVote.votes_attributes =
            proposal_id: 123

          response =
            proposal_id: 627
            comment: 'A million reasons to vote for this guy!'

          VotingService.saveVote()

          $httpBackend
            .expectPOST '/votes'
            .respond 201, response

          $httpBackend.flush()

          expect $location.url()
            .toEqual '/proposals/627?filter=my#navigationBar'
