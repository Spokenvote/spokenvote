describe "API Resources Tests", ->
  $httpBackend = undefined
  Hub = undefined
  Proposal = undefined
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'

  describe 'Hub $resource should load hubs', ->
    beforeEach inject (_$httpBackend_, $rootScope, $controller, SessionSettings, _Hub_) ->

      Hub = _Hub_
      $httpBackend = _$httpBackend_

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
