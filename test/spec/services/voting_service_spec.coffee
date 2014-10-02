describe 'Voting Service Tests', ->
  beforeEach ->
    module 'spokenvote'
  #    module 'spokenvoteMocks'

  describe 'ProposalShowCtrl should perform a Controller tasks', ->
    $rootScope = undefined
    $httpBackend = undefined
    VotingService = undefined
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

    beforeEach inject (_$rootScope_, _$httpBackend_, _VotingService_, _SessionSettings_, _$location_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      VotingService = _VotingService_
#      $location = _$location_
      $rootScope.sessionSettings = _SessionSettings_
      $rootScope.alertService =
        clearAlerts: jasmine.createSpy('alertService:clearAlerts')
#      $scope = $rootScope.$new()
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

    it 'should respond to SUPPORT method', ->
      VotingService.support clicked_proposal

#      expect $rootScope.sessionSettings.newSupport.target


