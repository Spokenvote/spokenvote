describe "Controllers", ->
  $scope = undefined
  ctrl = undefined

  #Indicate module in a test beforeEach(module('App')); beforeEach(function() {
  beforeEach module("App")
  beforeEach ->
    @addMatchers toEqualData: (expected) ->
      angular.equals @actual, expected

  # Controller describes
  describe "ProposalListCtrl", ->
    mockBackend = undefined
    recipe = undefined
    proposal = Proposal
    mockBackend = _$httpBackend_
    $scope = $rootScope.$new()
    ctrl = $controller("ProposalListCtrl",
      $scope: $scope
      proposals: [1, 2, 3]
    )
    it "should have list of proposals", ->
      expect($scope.proposals).toEqual [1, 2, 3]

