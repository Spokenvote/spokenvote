describe "Controllers", ->
  $scope = undefined
  ctrl = undefined
  beforeEach module("spokenvote")
  beforeEach ->
    @addMatchers toEqualData: (expected) ->
      angular.equals @actual, expected

  describe "ProposalListCtrl", ->
    mockBackend = undefined
    proposal = undefined
    beforeEach inject(($rootScope, $controller, _$httpBackend_, Proposal) ->
      proposal = Proposal
      mockBackend = _$httpBackend_
      $scope = $rootScope.$new()
      ctrl = $controller("ProposalListCtrl",
        $scope: $scope
        proposals: [ 1, 2, 3 ]
      )
    )
    it "should have list of proposals", ->
      expect($scope.proposals).toEqual [ 1, 2, 3 ]

  describe "MultiProposalLoader", ->
    mockBackend = undefined
    proposal = undefined
    loader = undefined
    routeParams = undefined
    beforeEach inject((_$httpBackend_, Proposal, MultiProposalLoader, $location, $routeParams) ->
      proposal = Proposal
      mockBackend = _$httpBackend_
      loader = MultiProposalLoader

      $location.path('/proposals')
      $location.search('hub', 1)
      $location.search('filter', 'active')
      $location.search('user', 42)

      routeParams = $routeParams
#      routeParams =
#        current:
#          params: {}
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
      mockBackend.expectGET("/assets/pages/landing.html.haml").respond []
      proposals = undefined
      promise = loader(
        $routeParams: routeParams
        $route:
          current: {}
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

#  describe "EditController", ->
#    mockBackend = undefined
#    location = undefined
#    beforeEach inject(($rootScope, $controller, _$httpBackend_, $location, Proposal) ->
#      mockBackend = _$httpBackend_
#      location = $location
#      $scope = $rootScope.$new()
#      ctrl = $controller("EditCtrl",
#        $scope: $scope
#        $location: $location
#        proposal: new Proposal(
#          id: 1
#          title: "Proposal"
#        )
#      )
#    )
#    it "should save the proposal", ->
#      mockBackend.expectPOST("/proposals/1",
#        id: 1
#        title: "Proposal"
#      ).respond id: 2
#      location.path "test"
#      $scope.save()
#      expect(location.path()).toEqual "/test"
#      mockBackend.flush()
#      expect(location.path()).toEqual "/view/2"
#
#    it "should remove the proposal", ->
#      expect($scope.proposal).toBeTruthy()
#      location.path "test"
#      $scope.remove()
#      expect($scope.proposal).toBeUndefined()
#      expect(location.path()).toEqual "/"