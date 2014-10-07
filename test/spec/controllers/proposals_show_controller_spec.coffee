describe 'Proposal Show Controller Tests', ->
  beforeEach ->
    module 'spokenvote'
#    module 'spokenvoteMocks'

  describe 'ProposalShowCtrl should perform a Controller tasks', ->
    $rootScope = undefined
    $httpBackend = undefined
    $location = undefined
    $scope = undefined
    ctrl = undefined
    mockProposal =
      id: 1
      statement: 'My Proposal'
    mockRelatedProposals = [ 1, 2, 3 ]
    clicked_proposal =
      id: '17'
      proposal:
        statement: 'My proposal statement'
        votes_attributes:
          comment: 'Why you should vote for this proposal'

    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _SessionSettings_, _$location_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $location = _$location_
      $rootScope.sessionSettings = _SessionSettings_
      $scope = $rootScope.$new()
      ctrl = _$controller_ 'ProposalShowCtrl',
        $scope: $scope
        proposal: mockProposal
        relatedProposals: mockRelatedProposals
      spyOn($scope, '$broadcast').and.callThrough()
      $scope.proposal.$get = jasmine.createSpy('proposal:$get')
      promise =
        then: jasmine.createSpy()
      $rootScope.authService =
        signinFb: jasmine.createSpy('authService').and.returnValue promise
      $rootScope.votingService =
        support: jasmine.createSpy('votingService:support')
        improve: jasmine.createSpy('votingService:improve')
        edit: jasmine.createSpy('votingService:edit')
        delete: jasmine.createSpy('votingService:delete')

    it 'should initialize scope items', ->
      expect $scope.proposal
        .toEqual mockProposal
      expect $scope.relatedProposals
        .toEqual mockRelatedProposals
      expect $scope.sessionSettings.actions.detailPage
        .toBe true
      expect $scope.$$listeners      # Not wild about this code, really want it to see 'event:votesChanged' but can't address that exact complex object
        .toBeDefined()
#        .toContain("{event:votesChanged}") # Sure seems this line would work, but does not
      expect $scope.hubView
        .toBeDefined()
      expect $scope.setVoter
        .toBeDefined()
      expect $scope.support
        .toBeDefined()
      expect $scope.improve
        .toBeDefined()
      expect $scope.edit
        .toBeDefined()
      expect $scope.delete
        .toBeDefined()
      expect $scope.tooltips
        .toBeDefined()
      expect $scope.socialSharing
        .toBeDefined()

    it 'should invoke $scope.proposal.$get() when "event:votesChanged" broadcasted', ->
      $scope.$broadcast 'event:votesChanged'

      expect $scope.$broadcast
        .toHaveBeenCalledWith 'event:votesChanged'
      expect $scope.proposal.$get.calls.count()
        .toEqual 1

    it 'should invoke hubView if selected', ->
      $scope.proposal.hub =
        id: 9

      $scope.hubView()

      expect $location.url()
        .toBe '/proposals?hub=9'

    it 'should invoke setVoter if selected', ->
      vote =
        user_id: 11
        username: 'Democracy Don'

      $scope.setVoter vote

      expect $location.url()
        .toBe '/proposals?user=11'
      expect $scope.sessionSettings.actions.userFilter
        .toBe 'Democracy Don'

    it 'should invoke signinFb if user tries to SUPPORT a proposal and is not signed in', ->
      $rootScope.currentUser = {}
      $scope.support clicked_proposal

      expect $rootScope.authService.signinFb.calls.count()
        .toEqual 1

    it 'should allow signed in Fb user to SUPPORT a proposal', ->
      $rootScope.currentUser =
        id: 5
      $scope.support clicked_proposal

      expect $rootScope.votingService.support.calls.count()
        .toEqual 1
      expect $rootScope.authService.signinFb.calls.any()
        .toBe false

    it 'should invoke signinFb if user tries to IMPROVE a proposal and is not signed in ', ->
      $rootScope.currentUser = {}
      $scope.improve clicked_proposal

      expect $rootScope.authService.signinFb.calls.count()
        .toEqual 1

    it 'should allow signed in Fb user to IMPROVE a proposal', ->
      $rootScope.currentUser =
        id: 5
      $scope.improve clicked_proposal

      expect $rootScope.votingService.improve.calls.count()
        .toEqual 1
      expect $rootScope.authService.signinFb.calls.any()
        .toBe false

    it 'should allow user to EDIT a proposal', ->
#      $rootScope.currentUser =                                         # TODO: Add real tests for edit and delete
#        id: 5
      $scope.edit clicked_proposal

      expect $rootScope.votingService.edit.calls.count()
        .toEqual 1
#      expect $rootScope.authService.signinFb.calls.any()
#        .toBe false

    it 'should allow user to DELETE a proposal', ->
#      $rootScope.currentUser =
#        id: 5
      $scope.delete clicked_proposal

      expect $rootScope.votingService.delete.calls.count()
        .toEqual 1
#      expect $rootScope.authService.signinFb.calls.any()
#        .toBe false

