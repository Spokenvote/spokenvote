describe "Controllers Test", ->
#  $scope = undefined
#  ctrl = undefined
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
    proposal = undefined
    ctrl = undefined
    beforeEach inject ($rootScope, $controller, _$httpBackend_, SessionSettings) ->
#    beforeEach inject(($rootScope, $controller, _$httpBackend_, Proposal) ->
      mockBackend = _$httpBackend_
      $rootScope.sessionSettings = SessionSettings
      scope = $rootScope.$new()
      ctrl = $controller "ProposalListCtrl",
        $scope: scope
#        test: 'test'
#        proposals: [ 1, 2, 3 ]

    it "should have list of proposals", ->
      expect(ctrl.scope.proposals).toEqual [ 1, 2, 3 ]
      expect(ctrl.test).toEqual 'kim'

#    it "self.test = kim", ->
#      expect(ctrl.test).toEqual 'kim'

    it "should match (second time)", ->
      expect("string").toMatch new RegExp("^string$")

