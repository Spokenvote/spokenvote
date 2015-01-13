describe 'StartController Tests', ->
  beforeEach module 'spokenvote', 'spokenvoteMocks'
#  beforeEach module 'spokenvoteMocks'
  $httpBackend = undefined
  beforeEach inject (_$httpBackend_) ->
    $httpBackend = _$httpBackend_

  describe 'StartController performs its Controller tasks ', ->
    $rootScope = undefined
    $scope = undefined
    ctrl = undefined
    Focus = jasmine.createSpy 'Focus'

    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _SessionSettings_, _Focus_) ->
      $rootScope = _$rootScope_
      $rootScope.sessionSettings = _SessionSettings_
      #      $location = _$location_
      #      VotingService = _VotingService_
      #      Proposal = _Proposal_
      $rootScope.alertService =
        clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
        setInfo: jasmine.createSpy 'alertService:setInfo'
        setCtlResult: jasmine.createSpy 'alertService:setCtlResult'
        setSuccess: jasmine.createSpy 'alertService:setSuccess'
        setJson: jasmine.createSpy 'alertService:setJson'
      $rootScope.currentUser =
        id: 5
      $scope = $rootScope.$new()
#      Focus = _Focus_
      spyOn window, 'Focus'
#      Focus = jasmine.createSpy()

      ctrl = _$controller_ 'StartController',
        $scope: $scope


    it 'StartController should initialize', ->
      expect $rootScope.alertService.clearAlerts.calls.count()
        .toEqual 1
      expect $scope.sessionSettings.actions.newProposal.prop
        .toEqual 'active'

#      expect window.Focus
#        .toHaveBeenCalledWith('proposal_statement')
#      expect Focus.calls.count()
#        .toEqual 1
#      expect Focus.fakeMethod.calls.count()
#        .toEqual 1
#      expect VotingService.support
#        .toBeDefined()

      expect Focus
        .toBeDefined()
      expect $scope.commentStep
        .toBeDefined()
      expect $scope.hubStep
        .toBeDefined()
      expect $scope.hubStep
        .toBeDefined()


