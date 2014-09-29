describe "API Test", ->
#  $scope = undefined
#  rootScope = undefined
  $httpBackend = undefined
  Hub = undefined
  Proposal = undefined
  multiProposalLoader = undefined
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'

  beforeEach module ($provide) ->
    -> $provide.value '$route',
      current:
        params:
          hub: 1
          filter: 'active'
          user: 42

  describe 'Hub $resource should load hubs', ->
    beforeEach inject (_$httpBackend_, $rootScope, $controller, SessionSettings, _Hub_) ->
#      $rootScope.sessionSettings = SessionSettings
#      rootScope = $rootScope
#      $scope.proposals = {}

      Hub = _Hub_
      $httpBackend = _$httpBackend_

#      $scope = $rootScope.$new()

      afterEach ->
        $httpBackend.verifyNoOutstandingExpectation()
        $httpBackend.verifyNoOutstandingRequest()

    it 'should load list of hubs', ->
#      $httpBackend.expectGET('/proposals?filter=active&hub=1&user=42')
#      $httpBackend
#        .whenGET '/hubs'
#        .whenGET '/hubs?filter=abc'
#        .respond [ 1, 2, 3 ]
#      expect($scope.proposals).toBeUndefined()
#      expect Hub()
#        .toBeDefined()

#      hubsResult = Hub.get(
#        id: undefined
#      )

#      promise.then (data) ->
#        proposals = data

      # Simulate a server response
#      $httpBackend.flush()

#      expect hubsResult instanceof Array
#        .toBeTruthy()
#      expect(hubsResult).toEqual([ 1, 2, 3 ])

  describe 'Proposal $resource should load, update proposals', ->
    beforeEach inject (_$httpBackend_, $rootScope, $controller, SessionSettings, _Proposal_) ->
      Proposal = _Proposal_
      $httpBackend = _$httpBackend_

      afterEach ->
        $httpBackend.verifyNoOutstandingExpectation()
        $httpBackend.verifyNoOutstandingRequest()

    it 'should CREATE a new proposal', ->
      newProposal =
        proposal:
          statement: 'My proposal statement'
          votes_attributes:
            comment: 'Why you should vote for this proposal'

      $httpBackend
        .expectPOST '/proposals'
        .respond newProposal

      proposalsResult = Proposal.save newProposal
      $httpBackend.flush()

      expect proposalsResult.proposal instanceof Object
        .toBeTruthy()
      expect proposalsResult.proposal
        .toEqual newProposal.proposal

    it 'should RETRIEVE list of proposals', ->
      $httpBackend
        .expectGET '/proposals'
        .respond proposals: [ 1, 2, 3 ]

      proposalsResult = Proposal.get()
      $httpBackend.flush()

      expect proposalsResult.proposals instanceof Array
        .toBeTruthy()
      expect proposalsResult.proposals
        .toEqual [ 1, 2, 3 ]

    it 'should RETRIEVE list of proposals accepting FILTER options', ->
      $httpBackend
        .expectGET '/proposals?filter=active&hub=1&user=42'
        .respond proposals: [ 5, 8, 11 ]

      proposalsResult = Proposal.get
        filter: 'active'
        hub: '1'
        user: '42'

      $httpBackend.flush()

      expect proposalsResult.proposals instanceof Array
        .toBeTruthy()
      expect proposalsResult.proposals
        .toEqual [ 5, 8, 11 ]

    it 'should UPDATE proposal and vote', ->
      editedProposal =
        id: '55'
        proposal:
          statement: 'My proposal statement'
          votes_attributes:
            comment: 'Why you should vote for this proposal'
            id: '125'

      $httpBackend
        .expectPUT '/proposals/55'
        .respond editedProposal

      proposalResult = Proposal.update editedProposal
      $httpBackend.flush()

      expect proposalResult.proposal instanceof Object
        .toBeTruthy()
      expect proposalResult.proposal
        .toEqual editedProposal.proposal

    it 'should DELETE proposal', ->
      clickedProposal =
        id: '99'

      $httpBackend
        .expectDELETE '/proposals/99'
        .respond status: 'success'

      proposalResult = Proposal.delete clickedProposal
      $httpBackend.flush()

      expect proposalResult instanceof Object
        .toBeTruthy()
      expect proposalResult.status
        .toEqual 'success'

  describe "MultiProposalLoader should load three proposals", ->
    beforeEach inject (_$httpBackend_, $rootScope, $controller, SessionSettings, MultiProposalLoader) ->
#      $rootScope.sessionSettings = SessionSettings
#      rootScope = $rootScope
#      $scope.proposals = {}

      multiProposalLoader = MultiProposalLoader
      $httpBackend = _$httpBackend_

#      $scope = $rootScope.$new()

      afterEach ->
        $httpBackend.verifyNoOutstandingExpectation()
        $httpBackend.verifyNoOutstandingRequest()

    it "should load list of proposals", ->
#      $httpBackend.expectGET('/proposals?filter=active&hub=1&user=42')
      $httpBackend
        .whenGET '/proposals?filter=active&hub=1&user=42'
        .respond [ 1, 2, 3 ]
#      expect($scope.proposals).toBeUndefined()
      expect multiProposalLoader()
        .toBeDefined()

      promise = multiProposalLoader()
      proposals = undefined

      promise.then (data) ->
        proposals = data

      # Simulate a server response
      $httpBackend.flush()

      expect proposals instanceof Array
        .toBeTruthy()
      expect(proposals).toEqual([ 1, 2, 3 ])

#      ready  = false
#      result = undefined
#      runs ->
#        defer = multiProposalLoader()
#        console.log "defer: ", defer
#        defer.then (onResponse = (data) ->
#          result = data
#          ready = true # continue test runner
#        ), onError = (fault) ->
#          ready = true # continue test runner
#        $httpBackend.flush()
#
#      waitsFor ->
#        result
#
#      # Run the code that checks the expectations…
#      runs ->
#        console.log 'result: ', result.$promise.finally
#        expect(result.valid).toBeEqual 1
#        expect(result.level).toBeEqual "awesome"

#      $httpBackend.expectGET("/assets/pages/landing.html").respond []
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
#      $httpBackend.flush()
#      expect(proposals).toEqualData [
#        id: 1
#      ,
#        id: 2
#      ]


    it "should reject the promise and respond with error", ->
      #      $httpBackend.expectGET('/proposals?filter=active&hub=1&user=42')
      $httpBackend
        .whenGET '/proposals?filter=active&hub=1&user=42'
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