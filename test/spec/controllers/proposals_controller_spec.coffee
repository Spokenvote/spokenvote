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

  describe "NewProposalCtrl", ->
    mockBackend = undefined
    location = undefined
    beforeEach inject(($rootScope, $controller, _$httpBackend_, $location, Proposal, SessionSettings) ->
      mockBackend = _$httpBackend_
      location = $location
      $scope = $rootScope.$new()
      $scope.sessionSettings = SessionSettings
      $scope.sessionSettings =
        hub_attributes:
          id: 1
          group_name: 'Hacker Dojo'
      $scope.newProposal =
        statement: "Jasmine test proposal"
        comment: "Jasmine test proposal comment"
      $dialog =
        close: -> ''
      ctrl = $controller("NewProposalCtrl",
        $scope: $scope
        parentScope: $scope
        dialog: $dialog
        $location: $location
        proposal: new Proposal(
          proposal:
            id: 1
            statement: "Jasmine test proposal"
            votes_attributes:
              comment: "Jasmine test proposal comment"
            hub_id: 1
            hub_attributes:
              group_name: 'Hacker Dojo'
        )
      )
    )
    it "should save the proposal", ->
      mockBackend.expectPOST("/proposals",
        proposal:
          statement: "Jasmine test proposal"
          votes_attributes:
            comment: "Jasmine test proposal comment"
          hub_id: 1
          hub_attributes:
            id: 1
            group_name: 'Hacker Dojo'
      ).respond id: 2
      location.path "test"
      $scope.saveNewProposal()
      expect(location.path()).toEqual "/test"
      mockBackend.flush()
      expect(location.path()).toEqual "/proposals/"


  describe "DeleteProposalCtrl", ->
    mockBackend = undefined
    location = undefined
    beforeEach inject(($rootScope, $controller, _$httpBackend_, $location) ->
      mockBackend = _$httpBackend_
      location = $location
      $scope = $rootScope.$new()
      prntScope =
        clicked_proposal:
          id: 1
          votes: ['']
      $dialog =
        close: -> ''
      ctrl = $controller("DeleteProposalCtrl",
        $scope: $scope
        parentScope: prntScope
        dialog: $dialog
        $location: $location
      )
    )
    it "should delete the proposal", ->
      mockBackend.expectDELETE("/proposals/1?votes=",
      ).respond []
      location.path "test"
      $scope.deleteProposal()
      expect(location.path()).toEqual "/test"
      mockBackend.flush()
      expect(location.path()).toEqual "/proposals"
