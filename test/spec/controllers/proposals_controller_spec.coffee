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
      ctrl = _$controller_ "ProposalListCtrl",
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

    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _SessionSettings_) ->
      $rootScope = _$rootScope_
      $rootScope.sessionSettings = _SessionSettings_
      $scope = $rootScope.$new()
      ctrl = _$controller_ "ProposalListCtrl",
        $scope: $scope

    it 'should have loaded list of proposals', ->
      $scope.$apply()
      expect $scope.proposals
        .toEqual [ 1, 2, 3 ]
      expect $scope.proposalsLoading
        .toBe false
