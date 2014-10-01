describe 'Proposals Controllers Test', ->
  beforeEach ->
    module 'spokenvote'
    module 'spokenvoteMocks'

  describe 'ProposalListCtrl should  .... ', ->
    $rootScope = undefined
    $scope = undefined
    ctrl = undefined

    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _SessionSettings_) ->
      $rootScope = _$rootScope_
      $rootScope.sessionSettings = _SessionSettings_
      $scope = $rootScope.$new()
      ctrl = _$controller_ 'ProposalListCtrl',
        $scope: $scope

    it 'should have loaded list of proposals', ->
      $scope.$apply()
      expect $scope.proposals
        .toEqual [ 1, 2, 3 ]
      expect $scope.proposalsLoading
        .toBe false

  describe 'ProposalShowCtrl should  .... ', ->
    $rootScope = undefined
    $scope = undefined
    ctrl = undefined
    mockProposal = undefined
#    mockProposal = {id: 1, statement: 'My Proposal'}
    mockRelatedProposals = [ 1, 2, 3 ]
    clicked_proposal =
      id: '17'
      proposal:
        statement: 'My proposal statement'
        votes_attributes:
          comment: 'Why you should vote for this proposal'


    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _SessionSettings_, _ProposalLoader_) ->
      $rootScope = _$rootScope_
      $rootScope.sessionSettings = _SessionSettings_
      $scope = $rootScope.$new()
      mockProposal = _ProposalLoader_
      ctrl = _$controller_ 'ProposalShowCtrl',
        $scope: $scope
        proposal: mockProposal
        relatedProposals: mockRelatedProposals
      spyOn $scope, '$broadcast'
        .and.callThrough()
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
#      $scope.$apply()
      expect $scope.proposal
        .toEqual mockProposal
      expect $scope.relatedProposals
        .toEqual mockRelatedProposals
      expect $scope.sessionSettings.actions.detailPage
        .toBe true
      expect $scope.$$listeners      # Not wild about this code, really want it to see 'event:votesChanged' but can't address that exact complex object
        .toBeDefined()

#    it 'should invoke event:votesChanged when "event:votesChanged" broadcasted', ->
#      $scope.$broadcast('event:votesChanged')
#      expect($scope.$broadcast).toHaveBeenCalledWith('event:votesChanged')

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

    it 'should invoke signinFb if user tries to SUPPORT a proposal and is not signed in ', ->
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

#    it 'should have loaded list of proposals', ->
#      $scope.$apply()
#      expect $scope.proposals
#        .toEqual [ 1, 2, 3 ]
#      expect $scope.proposalsLoading
#        .toBe false
