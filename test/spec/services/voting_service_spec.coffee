describe 'Voting Service Tests', ->
  beforeEach ->
    module 'spokenvote'
  #    module 'spokenvoteMocks'

  describe 'ProposalShowCtrl should perform a Controller tasks', ->
    $rootScope = undefined
    $httpBackend = undefined
    VotingService = undefined
    $location = undefined
    scope = undefined
    ctrl = undefined
    mockProposal =
      id: 1
      statement: 'My Proposal'
    mockRelatedProposals = [ 1, 2, 3 ]
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

    beforeEach inject (_$rootScope_, _$httpBackend_, _VotingService_, _SessionSettings_, _$location_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
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
#      ctrl = _$controller_ 'ProposalShowCtrl',
#        $scope: $scope
#        proposal: mockProposal
#        relatedProposals: mockRelatedProposals
#      spyOn $scope, '$broadcast'
#        .and.callThrough()
#      promise =
#        then: jasmine.createSpy()
#      $rootScope.authService =
#        signinFb: jasmine.createSpy('authService').and.returnValue promise
#      $rootScope.votingService =
#        support: jasmine.createSpy('votingService:support')
#        improve: jasmine.createSpy('votingService:improve')
#        edit: jasmine.createSpy('votingService:edit')
#        delete: jasmine.createSpy('votingService:delete')

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
      relatedSupport.proposal.id = 8
      SupportCtrl = jasmine.createSpy('SupportCtrl')
      VotingService.support clicked_proposal

      $httpBackend
        .expectGET '/proposals/17/related_vote_in_tree'
        .respond relatedSupport
      $httpBackend
        .expectGET 'proposals/_support_modal.html'
        .respond 'success'
      $httpBackend
        .expectGET 'template/modal/backdrop.html'
        .respond 'success'
      $httpBackend
        .expectGET 'template/modal/window.html'
        .respond 'success'

      $httpBackend.flush()

      expect $rootScope.sessionSettings.newSupport.related
        .toEqual jasmine.objectContaining null
      expect $rootScope.alertService.setInfo
        .not.toHaveBeenCalled()
      expect $rootScope.alertService.setInfo
        .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)

#      $httpBackend
#        .expectGET '/proposals/55'
#        .respond editedProposal

#      expect $rootScope.alertService.setInfo.calls.count()
#        .toEqual 1