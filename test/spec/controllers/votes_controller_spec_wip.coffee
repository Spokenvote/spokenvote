# Much of this functionality moved to voting service; tests need a rewrite

describe "Proposal Controller Tests", ->
  $scope = undefined
  ctrl = undefined
  beforeEach module 'spokenvote'
  beforeEach module 'spokenvoteMocks'

  beforeEach ->
    @addMatchers toEqualData: (expected) ->
      angular.equals @actual, expected


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
      expect(location.path()).toEqual "/proposals/2"


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
