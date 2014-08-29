describe "Controllers Test", ->
  $scope = undefined
  ctrl = undefined
  beforeEach module 'spokenvote'

  angular.module 'spokenvoteMocks', []
    .factory 'MultiProposalLoader', ($q) ->
      ->
        delay = $q.defer()
        proposals = [ 1, 2, 3 ]
        delay.resolve proposals
        delay.promise

  beforeEach module 'spokenvoteMocks'

  beforeEach ->
    @addMatchers toEqualData: (expected) ->
      angular.equals @actual, expected

  describe "Initial Validation Test", ->
    it "should match", ->
      expect("string").toMatch new RegExp("^string$")

  describe "ProposalListCtrl in Learning", ->
    mockBackend = undefined
    ctrl = undefined
    beforeEach inject ($rootScope, $controller, _$httpBackend_, SessionSettings) ->
#      mockBackend = _$httpBackend_
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      ctrl = $controller "ProposalListCtrl",
        $scope: $scope

    it "should have loaded list of proposals", ->
      $scope.$apply()
      expect($scope.proposals).toEqual [ 1, 2, 3 ]
      expect($scope.proposalsLoading).toBe false

    it "should match (second time)", ->
      expect("string").toMatch new RegExp("^string$")

