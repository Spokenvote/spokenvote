describe "API Test", ->
  $scope = undefined
#  rootScope = undefined
  $httpBackend = undefined
  Hub = undefined
  Proposal = undefined
  multiProposalLoader = undefined
  proposalLoader = undefined
  currentHubLoader = undefined
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'

  describe "CurrentHubLoader should load current hub", ->
    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            hub: 1
            filter: 'active'
            user: 42

    beforeEach inject (_$httpBackend_, $rootScope, $controller, SessionSettings, CurrentHubLoader) ->
#      $rootScope.sessionSettings = SessionSettings
#      rootScope = $rootScope
#      $scope.proposals = {}

      currentHubLoader = CurrentHubLoader
      $httpBackend = _$httpBackend_

#      $scope = $rootScope.$new()

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should load list of hubs", ->
      $httpBackend.expectGET '/hubs/1'
        .respond {}

      expect currentHubLoader()
        .toBeDefined()

      $httpBackend.flush()


  describe "ProposalLoader should load a proposal", ->
    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            proposalId: 23

    beforeEach inject (_$httpBackend_, $rootScope, $controller, SessionSettings, ProposalLoader) ->
#      rootScope = $rootScope
#      rootScope.sessionSettings = SessionSettings

      proposalLoader = ProposalLoader
      $httpBackend = _$httpBackend_
      $scope = $rootScope.$new()
      $scope.proposals = undefined

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should load a proposal", ->
      $httpBackend.expectGET '/proposals/23'
        .respond {}

      expect($scope.proposals).toBeUndefined()
      expect proposalLoader()
        .toBeDefined()

      $httpBackend.flush()

    it "ProposalLoader should return a promise", ->
      $httpBackend.expectGET '/proposals/23'
        .respond {}

      promise = proposalLoader()

      promise.then (data) ->
        proposals = data

      $httpBackend.flush()

    it "ProposalLoader promise should return an array", ->
      $httpBackend.expectGET '/proposals/23'
        .respond {}

      promise = proposalLoader()

      proposal = undefined
      promise.then (data) ->
        proposal = data

      $httpBackend.flush()
      console.log 'proposal: ', proposal

      expect proposal instanceof Object
        .toBeTruthy()
#      expect(proposals).toEqual([ 1, 2, 3 ])

#    it "should reject the promise and respond with error", ->
#      $httpBackend.expectGET '/proposals?filter=active&hub=1&user=42'
#        .respond 500
#
#      promise = multiProposalLoader()
#      proposals = undefined
#
#      promise.then (data) ->
#        proposals = data
#
#      promise.then (fruits) ->
#        proposals = fruits
#      , (reason) ->
#        proposals = reason
#
#      $httpBackend.flush()
#
#      expect proposals
#        .toContain 'Unable'


  describe "MultiProposalLoader should load three proposals", ->
    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            hub: 1
            filter: 'active'
            user: 42

    beforeEach inject (_$httpBackend_, $rootScope, $controller, SessionSettings, MultiProposalLoader) ->
#      rootScope = $rootScope
#      rootScope.sessionSettings = SessionSettings

      multiProposalLoader = MultiProposalLoader
      $httpBackend = _$httpBackend_
      $scope = $rootScope.$new()
      $scope.proposals = undefined

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should load list of proposals", ->
      $httpBackend.expectGET '/proposals?filter=active&hub=1&user=42'
        .respond [ 1, 2, 3 ]

      expect($scope.proposals).toBeUndefined()
      expect multiProposalLoader()
        .toBeDefined()

      $httpBackend.flush()

    it "MultiProposalLoader should return a promise", ->
      $httpBackend.expectGET '/proposals?filter=active&hub=1&user=42'
        .respond [ 1, 2, 3 ]

      promise = multiProposalLoader()

      promise.then (data) ->
        proposals = data

      $httpBackend.flush()

    it "MultiProposalLoader promise should return an array", ->
      $httpBackend.expectGET '/proposals?filter=active&hub=1&user=42'
        .respond [ 1, 2, 3 ]

      promise = multiProposalLoader()

      proposals = undefined
      promise.then (data) ->
        proposals = data

      $httpBackend.flush()

      expect proposals instanceof Array
        .toBeTruthy()
      expect(proposals).toEqual([ 1, 2, 3 ])


    it "should reject the promise and respond with error", ->
      $httpBackend.expectGET '/proposals?filter=active&hub=1&user=42'
        .respond 500

      promise = multiProposalLoader()
      proposals = undefined

      promise.then (data) ->
        proposals = data

      promise.then (fruits) ->
        proposals = fruits
      , (reason) ->
        proposals = reason

      $httpBackend.flush()

      expect proposals
        .toContain 'Unable'
