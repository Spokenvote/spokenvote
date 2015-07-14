describe 'API Resources Tests', ->
  $httpBackend = undefined
  beforeEach module 'spokenvote'

  # Test Hub $resource
  describe 'Hub $resource should create, load, update, and delete hubs', ->
    Hub = undefined
    beforeEach inject (_$httpBackend_, _Hub_) ->
      Hub = _Hub_
      $httpBackend = _$httpBackend_

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it 'should CREATE a new proposal', ->
      newHub =
        hub:
          id: 10
          description: 'My group'

      $httpBackend
        .expectPOST '/hubs'
        .respond newHub

      hubsResult = Hub.save newHub
      $httpBackend.flush()

      expect hubsResult.hub instanceof Object
        .toBeTruthy()
      expect hubsResult.hub
        .toEqual hubsResult.hub

    it 'should RETRIEVE list of hubs', ->
      $httpBackend
        .expectGET '/hubs'
        .respond hubs: [ 1, 2, 3 ]

      hubsResult = Hub.get()
      $httpBackend.flush()

      expect hubsResult.hubs instanceof Array
        .toBeTruthy()
      expect hubsResult.hubs
        .toEqual [ 1, 2, 3 ]

    it 'should UPDATE hub', ->
      editedHub =
        id: '22'
        hub:
          id: 22
          description: 'My group'

      $httpBackend
        .expectPUT '/hubs/22'
        .respond editedHub

      hubResult = Hub.update editedHub
      $httpBackend.flush()

      expect hubResult.hub instanceof Object
        .toBeTruthy()
      expect hubResult.hub
        .toEqual editedHub.hub

    it 'should DELETE hub', ->
      clickedHub =
        id: '88'

      $httpBackend
        .expectDELETE '/hubs/88'
        .respond status: 'success'

      hubResult = Hub.delete clickedHub
      $httpBackend.flush()

      expect hubResult instanceof Object
        .toBeTruthy()
      expect hubResult.status
        .toEqual 'success'

  # Test Vote $resource
  describe 'Vote $resource should create, load, update, and delete votes', ->
    Vote = undefined
    beforeEach inject (_$httpBackend_, _Vote_) ->
      Vote = _Vote_
      $httpBackend = _$httpBackend_

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it 'should CREATE a new vote', ->
      newSupport =
        save:
          comment: 'Why I like this proposal.'

      $httpBackend
        .expectPOST '/votes'
        .respond newSupport

      votesResult = Vote.save newSupport
      $httpBackend.flush()

      expect votesResult.save instanceof Object
        .toBeTruthy()
      expect votesResult.save
        .toEqual newSupport.save

    it 'should RETRIEVE list of votes', ->
      $httpBackend
        .expectGET '/votes'
        .respond votes: [ 1, 2, 3 ]

      votesResult = Vote.get()
      $httpBackend.flush()

      expect votesResult.votes instanceof Array
        .toBeTruthy()
      expect votesResult.votes
        .toEqual [ 1, 2, 3 ]

    it 'should UPDATE vote', ->
      editedVote =
        id: '65'
        save:
          comment: 'Edit of why I like this proposal.'

      $httpBackend
        .expectPUT '/votes/65'
        .respond editedVote

      voteResult = Vote.update editedVote
      $httpBackend.flush()

      expect voteResult.save instanceof Object
        .toBeTruthy()
      expect voteResult.save
        .toEqual editedVote.save

    it 'should DELETE vote', ->
      clickedVote =
        id: '199'

      $httpBackend
        .expectDELETE '/votes/199'
        .respond status: 'success'

      voteResult = Vote.delete clickedVote
      $httpBackend.flush()

      expect voteResult instanceof Object
        .toBeTruthy()
      expect voteResult.status
        .toEqual 'success'

  # Test Proposal $resource
  describe 'Proposal $resource should create, load, update, and delete proposals', ->
    Proposal = undefined

    returnedProposalResponse =
      ancestry: null
      created_at: "2015-07-10T20:56:49.970Z"
      created_by: null
      hub_id: 1
      id: 258
      statement: "My Proposal"
      supporting_statement: null
      updated_at: "2015-07-10T22:46:48.516Z"
      user_id: 44
      votes_count: 1

    beforeEach inject (_$httpBackend_, _Proposal_) ->
      Proposal = _Proposal_
      $httpBackend = _$httpBackend_

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should LOAD a proposal", ->

      $httpBackend.expectGET '/proposals/1'
      .respond returnedProposalResponse

      proposal = Proposal.get id: 1

      $httpBackend.flush()

      expect proposal instanceof Object
      .toBeTruthy()
      expect proposal.statement
      .toEqual returnedProposalResponse.statement

    it 'should CREATE a new proposal', ->
      newProposal =
        proposal:
          statement: "My Proposal"
          votes_attributes:
            comment: "A great comment in support"
        hub_id: 1
        hub_attributes: {}

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
        hub_id: 1
        hub_attributes: {}

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


# Test UserOmniauthResource auth service
  describe 'UserOmniauthResource should respond to requests', ->
    UserOmniauthResource = undefined

    signInUser =
      auth:
        email: "te...or@gmail.com"
        expiresIn: 6770
        name: "Kim Miller"
        provider: "facebook"
        token: "CAAKPndevd1ABAL...7LyC0z5Uphqmlu6EMZD"
        uid: "101...417"

    signOutResponse =
      status: "You are signed out."
      success: true

    signInResponse =
      new_user_saved: true
      status: "You are signed in."
      success: true

    beforeEach inject (_$httpBackend_, _UserOmniauthResource_) ->
      $httpBackend = _$httpBackend_
      UserOmniauthResource = _UserOmniauthResource_

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it 'should SIGN IN a user', ->

      $httpBackend.expectPOST '/authentications'
      .respond signInResponse

      userOmniauth = new UserOmniauthResource
        auth: signInUser

      sessionResponse = userOmniauth.$save()

      $httpBackend.flush()

      expect sessionResponse instanceof Object
      .toBeTruthy()
      expect sessionResponse.$$state.value.data
      .toEqual signInResponse

    it 'should SIGN OUT a user', ->

      $httpBackend.expectDELETE '/users/logout'
      .respond signOutResponse

      userOmniauth = new UserOmniauthResource
        auth: signInUser

      sessionResponse = userOmniauth.$destroy()

      $httpBackend.flush()

      expect sessionResponse instanceof Object
      .toBeTruthy()
      expect sessionResponse.$$state.value.data
      .toEqual signOutResponse

