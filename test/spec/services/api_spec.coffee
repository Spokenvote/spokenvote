describe "Controllers Test", ->
  $scope = undefined
  ctrl = undefined
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'

  beforeEach ->
    @addMatchers toEqualData: (expected) ->
      angular.equals @actual, expected

  describe "Initial Validation Test", ->
    it "should match", ->
      expect("string").toMatch new RegExp("^string$")

  describe "MultiProposalLoader", ->
    mockBackend = undefined
    proposal = undefined
    loader = undefined
    routeParams = undefined
    beforeEach inject((_$httpBackend_, $location, $rootScope, $controller, SessionSettings) ->
      routeParams = {}
      routeParams.hub = 1
      routeParams.filter = 'active'
      routeParams.user = 42
      $rootScope.sessionSettings = SessionSettings

      $scope = $rootScope.$new()
      ctrl = $controller "ProposalListCtrl",
        $scope: $scope
#        $routeParams: routeParams
#
#        $route:
#          current:
#            hub: 1
#            filter: 'active'
#            user: 42
#      proposal = Proposal
      mockBackend = _$httpBackend_
#      loader = MultiProposalLoader

#      $location.path('/proposals')
#      $location.search('hub', 1)
#      $location.search('filter', 'active')
#      $location.search('user', 42)

#      $route:
#        current:
#          hub: 1
#          filter: 'active'
#          user: 42
#
#      $routeParams:
#        hub: 1
#        filter: 'active'
#        user: 42

    )
    it "should load list of proposals", ->
#      ctrl = $controller "ProposalListCtrl",
#        $scope: $scope
#        $routeParams: routeParams

#      mockBackend.expectGET("/proposals").respond [
#        id: 1
#      ,
#        id: 2
#      ]
#      mockBackend.expectGET("/assets/pages/landing.html").respond []
#      proposals = undefined
#      promise = loader(
##        $routeParams
##        $route:
##          current: {}
#      )
#      promise.then (prop) ->
#        proposals = prop
#
#      expect(proposals).toBeUndefined()
#      mockBackend.flush()
#      expect(proposals).toEqualData [
#        id: 1
#      ,
#        id: 2
#      ]
