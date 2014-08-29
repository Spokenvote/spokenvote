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
    beforeEach inject((_$httpBackend_, Proposal, MultiProposalLoader, $location, $rootScope, $controller) ->
      $scope = $rootScope.$new()
      ctrl = $controller "ProposalListCtrl",
        $scope: $scope
        $routeParams:
          hub: 1
          filter: 'active'
          user: 42
        $route:
          hub: 1
          filter: 'active'
          user: 42
      proposal = Proposal
      mockBackend = _$httpBackend_
      loader = MultiProposalLoader

      $location.path('/proposals')
      $location.search('hub', 1)
      $location.search('filter', 'active')
      $location.search('user', 42)

#      routeParams = $route
#      routeParams:
#        current:
#          params:
#            hub: 1
#            filter: 'active'
#            user: 42
    )
    it "should load list of proposals", ->
      mockBackend.expectGET("/proposals").respond [
        id: 1
      ,
        id: 2
      ]
      mockBackend.expectGET("/assets/pages/landing.html").respond []
      proposals = undefined
      promise = loader(
#        $routeParams
#        $route:
#          current: {}
      )
      promise.then (prop) ->
        proposals = prop

      expect(proposals).toBeUndefined()
      mockBackend.flush()
      expect(proposals).toEqualData [
        id: 1
      ,
        id: 2
      ]
