describe "API Test", ->
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'
  $httpBackend = undefined
  $rootScope = undefined
  $route = undefined
  returnedProposalList =
    id: 15,
    related_proposals: [
      {
        id: 49,
        statement: "Voter 1 has something better that is the max length you can make a proposal so Voter 2 can test supporting that max length text layout here.",
        user_id: 1,
        created_at: "2013-05-16 02:08:32 UTC",
        votes_count: 2,
        ancestry: "14/15",
        created_by: null,
        hub_id: 2,
        votes_in_tree: 6,
        votes_percentage: 33,
        is_editable: false,
        has_support: true,
        current_user_support: true,
        related_proposals_count: 1,
        user: {
          id: 1,
          email: "voter1@example.com",
          name: "Voter1",
          gravatar_hash: "d7c85daf2d627cc0d173d3bcff09a326",
          facebook_auth: null
        },
        hub: {
          id: 2,
          group_name: "Marriage Equality",
          formatted_location: "Solapur, Maharashtra, India",
          full_hub: "Marriage Equality - Solapur, Maharashtra, India"
        },
        votes: [
          {
            id: 63,
            comment: "ghghfdfdfd",
            username: "Kim ManAuth Miller",
            created_at: "2013-02-10 16:34:28 UTC",
            user_id: 42,
            email: "kimardenmiller@gmail.com",
            gravatar_hash: "3423a20950bd9efcc25a2e7657ff990c",
            facebook_auth: null,
            updated_at: "Over a year ago"
          },
          {
            id: 71,
            comment: "dfkdfdfjdjfk",
            username: "Voter1",
            created_at: "2013-05-16 02:08:32 UTC",
            user_id: 1,
            email: "voter1@example.com",
            gravatar_hash: "d7c85daf2d627cc0d173d3bcff09a326",
            facebook_auth: null,
            updated_at: "Over a year ago"
          }
        ]
      }
    ]
  clicked_proposal =
    id: 17
    statement: 'My proposal statement'
    votes: [
      id: 22
      comment: 'Why you should vote for this proposal']


  describe "Hub should respond to requests", ->
  describe "Vote should respond to requests", ->

  describe "Proposal should respond to requests", ->
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

    beforeEach module ($provide) ->
        -> $provide.value '$route',
          current:
            params:
              hub: 1
              filter: 'active'
              user: 42

    beforeEach inject (_$httpBackend_, _Proposal_) ->
      $httpBackend = _$httpBackend_
      Proposal = _Proposal_

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

    it "should SAVE a proposal", ->

      newProposal =
        proposal:
          statement: "My Proposal"
          votes_attributes:
            comment: "A great comment in support"
        hub_id: 1
        hub_attributes: {}

      $httpBackend.expectPOST '/proposals'
        .respond returnedProposalResponse

      proposal = Proposal.save newProposal

      $httpBackend.flush()

      expect proposal instanceof Object
        .toBeTruthy()
      expect proposal.statement
        .toEqual returnedProposalResponse.statement

    it "should UPDATE proposal", ->

      newProposal =
        id: 258
        proposal:
          statement: "My Proposal"
          votes_attributes:
            comment: "A great comment in support"
        hub_id: 1
        hub_attributes: {}

      $httpBackend.expectPUT '/proposals/258'
        .respond returnedProposalResponse

      proposal = Proposal.update newProposal

      $httpBackend.flush()

      expect proposal instanceof Object
        .toBeTruthy()
      expect proposal.statement
        .toEqual returnedProposalResponse.statement


  describe "UserOmniauthResource should respond to requests", ->
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

    it "should SIGN IN a user", ->

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

    it "should SIGN OUT a user", ->

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


#    it "should SAVE a proposal", ->
#
#      newProposal =
#        proposal:
#          statement: "My Proposal"
#          votes_attributes:
#            comment: "A great comment in support"
#        hub_id: 1
#        hub_attributes: {}
#
#      $httpBackend.expectPOST '/proposals'
#        .respond returnedProposalResponse
#
#      proposal = Proposal.save newProposal
#
#      $httpBackend.flush()
#
#      expect proposal instanceof Object
#        .toBeTruthy()
#      expect proposal.statement
#        .toEqual returnedProposalResponse.statement
#
#    it "should UPDATE proposal", ->
#
#      newProposal =
#        id: 258
#        proposal:
#          statement: "My Proposal"
#          votes_attributes:
#            comment: "A great comment in support"
#        hub_id: 1
#        hub_attributes: {}
#
#      $httpBackend.expectPUT '/proposals/258'
#        .respond returnedProposalResponse
#
#      proposal = Proposal.update newProposal
#
#      $httpBackend.flush()
#
#      expect proposal instanceof Object
#        .toBeTruthy()
#      expect proposal.statement
#        .toEqual returnedProposalResponse.statement


  describe "CurrentHubLoader should respond to requests", ->
    currentHubLoader = undefined
    returnedHub =
      id: 1
      group_name: "Hacker Dojo"
      description: "Hacker Dojo"
      created_at: "2013-02-10T00:01:58.914Z"
      updated_at: "2013-02-10T00:01:58.914Z"

    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            hub: 1
            filter: 'active'
            user: 42

    beforeEach inject (_$httpBackend_, _$rootScope_, _$route_, CurrentHubLoader) ->
      $httpBackend = _$httpBackend_
      $rootScope = _$rootScope_
      $route = _$route_
      currentHubLoader = CurrentHubLoader

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should load the current hub", ->
      $httpBackend.expectGET '/hubs/1'
        .respond returnedHub

      promise = currentHubLoader()
      hub = undefined

      promise.then (data) ->
        hub = data

      $httpBackend.flush()

      expect hub instanceof Object
        .toBeTruthy()
      expect hub
        .toEqual jasmine.objectContaining {"id":1,"group_name":"Hacker Dojo","description":"Hacker Dojo","created_at":"2013-02-10T00:01:58.914Z","updated_at":"2013-02-10T00:01:58.914Z"}

    it "should return a promise", ->
      $httpBackend.expectGET '/hubs/1'
      .respond {"id":23,"statement":"Hacker Dojo should organize an annual startup launch event","user_id":43,"created_at":"2013-02-10 05:02:39 UTC"}

      promise = currentHubLoader()

      promise.then (data) ->
        hub = data

      $httpBackend.flush()

    it "should reject the promise and respond with error", ->
      $httpBackend.expectGET '/hubs/1'
      .respond 500

      promise = currentHubLoader()
      proposal = undefined

      promise.then (fruits) ->
        proposal = fruits
      , (reason) ->
        proposal = reason

      $httpBackend.flush()

      expect proposal
        .toContain 'Unable'

    it "should reject a missing hub filter", ->

      $route.current.params.hub = null
      promise = currentHubLoader()
      proposal = undefined

      promise.then (fruits) ->
        proposal = fruits
      , (reason) ->
        proposal = reason

      $rootScope.$apply()

      expect proposal
        .toContain 'No Hub ID'


  describe "SelectHubLoader should respond to requests", ->

    selectHubLoader = undefined

    beforeEach inject (_$httpBackend_, _$rootScope_, SelectHubLoader) ->
      $httpBackend = _$httpBackend_
      $rootScope = _$rootScope_
      selectHubLoader = SelectHubLoader

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should load the current hub", ->
      $httpBackend.expectGET '/hubs?hub_filter=ha'
        .respond [ {"id":1,"group_name":"Hacker Dojo"}, {"id":321,"group_name":"Hacker Doggies"}, {"id":676,"group_name":"Hacker Dummies"} ]

      hub_filter = 'ha'
      promise = selectHubLoader(hub_filter)
      hub = undefined

      promise.then (data) ->
        hub = data

      $httpBackend.flush()

      expect hub instanceof Object
        .toBeTruthy()
      expect hub
        .toEqual jasmine.objectContaining [ {"id":1,"group_name":"Hacker Dojo"}, {"id":321,"group_name":"Hacker Doggies"}, {"id":676,"group_name":"Hacker Dummies"} ]

    it "should return a promise", ->
      $httpBackend.expectGET '/hubs?hub_filter=ha'
        .respond [ {"id":1,"group_name":"Hacker Dojo"}, {"id":321,"group_name":"Hacker Doggies"}, {"id":676,"group_name":"Hacker Dummies"} ]

      hub_filter = 'ha'
      promise = selectHubLoader(hub_filter)

      promise.then (data) ->
        hub = data

      $httpBackend.flush()

    it "should reject the promise and respond with error", ->
      $httpBackend.expectGET '/hubs?hub_filter=ha'
        .respond 500

      hub_filter = 'ha'
      promise = selectHubLoader hub_filter
      proposal = undefined

      promise.then (fruits) ->
        console.log 'fruits: ', fruits
        proposal = fruits
      , (reason) ->
        proposal = reason

      $httpBackend.flush()

      expect proposal
        .toContain 'Unable'

    it "should reject a missing hub filter", ->

      hub_filter = null
      promise = selectHubLoader hub_filter
      proposal = undefined

      promise.then (fruits) ->
        proposal = fruits
      , (reason) ->
        proposal = reason

      $rootScope.$apply()

      expect proposal
        .toContain 'No Hub ID'


  describe "ProposalLoader should load a proposal", ->
    proposalLoader = undefined

    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            proposalId: 23

    beforeEach inject (_$httpBackend_, ProposalLoader) ->
      $httpBackend = _$httpBackend_
      proposalLoader = ProposalLoader

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should load a proposal", ->
      $httpBackend.expectGET '/proposals/23'
        .respond {"id":23,"statement":"Hacker Dojo should organize an annual startup launch event","user_id":43,"created_at":"2013-02-10 05:02:39 UTC"}
      expect proposalLoader()
        .toBeDefined()

      $httpBackend.flush()

    it "should return a promise", ->
      $httpBackend.expectGET '/proposals/23'
        .respond {"id":23,"statement":"Hacker Dojo should organize an annual startup launch event","user_id":43,"created_at":"2013-02-10 05:02:39 UTC"}

      promise = proposalLoader()

      promise.then (data) ->
        proposals = data

      $httpBackend.flush()

    it "should return a proposal via promise", ->
      $httpBackend.expectGET '/proposals/23'
        .respond {"id":23,"statement":"Hacker Dojo should organize an annual startup launch event","user_id":43,"created_at":"2013-02-10 05:02:39 UTC"}

      promise = proposalLoader()

      proposal = undefined
      promise.then (data) ->
        proposal = data

      $httpBackend.flush()

      expect proposal instanceof Object
        .toBeTruthy()
      expect proposal
        .toEqual jasmine.objectContaining {"id":23,"statement":"Hacker Dojo should organize an annual startup launch event","user_id":43,"created_at":"2013-02-10 05:02:39 UTC"}

    it "should reject the promise and respond with error", ->
      $httpBackend.expectGET '/proposals/23'
        .respond 500

      promise = proposalLoader()
      proposal = undefined

      promise.then (fruits) ->
        proposal = fruits
      , (reason) ->
        proposal = reason

      $httpBackend.flush()

      expect proposal
        .toContain 'Unable'


  describe "MultiProposalLoader should load three proposals", ->
    multiProposalLoader = undefined

    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            hub: 1
            filter: 'active'
            user: 42

    beforeEach inject (_$httpBackend_, MultiProposalLoader) ->
      $httpBackend = _$httpBackend_
      multiProposalLoader = MultiProposalLoader

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should load list of proposals", ->
      $httpBackend.expectGET '/proposals?filter=active&hub=1&user=42'
        .respond [ "id":23,"statement 23":"Hacker Dojo", "id":24,"statement24":"Hacker Dojo", "id":25,"statement 25":"Hacker Dojo" ]

      expect multiProposalLoader()
        .toBeDefined()

      $httpBackend.flush()

    it "should return a promise", ->
      $httpBackend.expectGET '/proposals?filter=active&hub=1&user=42'
        .respond [ "id":23,"statement 23":"Hacker Dojo", "id":24,"statement24":"Hacker Dojo", "id":25,"statement 25":"Hacker Dojo" ]

      promise = multiProposalLoader()

      expect promise.then instanceof Object
        .toBeTruthy()

      $httpBackend.flush()

    it "should return an array via promise", ->
      $httpBackend.expectGET '/proposals?filter=active&hub=1&user=42'
        .respond [ "id":23,"statement 23":"Hacker Dojo", "id":24,"statement24":"Hacker Dojo", "id":25,"statement 25":"Hacker Dojo" ]

      promise = multiProposalLoader()

      proposals = undefined
      promise.then (data) ->
        proposals = data

      $httpBackend.flush()

      expect proposals instanceof Array
        .toBeTruthy()
      expect proposals
        .toEqual [ "id":23,"statement 23":"Hacker Dojo", "id":24,"statement24":"Hacker Dojo", "id":25,"statement 25":"Hacker Dojo" ]


    it "should reject the promise and respond with error", ->
      $httpBackend.expectGET '/proposals?filter=active&hub=1&user=42'
        .respond 500

      promise = multiProposalLoader()
      proposals = undefined

      promise.then (fruits) ->
        proposals = fruits
      , (reason) ->
        proposals = reason

      $httpBackend.flush()

      expect proposals
        .toContain 'Unable'


  describe "RelatedProposalsLoader should load three proposals", ->
    RelatedProposalsLoader = undefined

    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            proposalId: 15
#            hub: 1
#            filter: 'active'
#            user: 42

    beforeEach inject (_$httpBackend_, _RelatedProposalsLoader_) ->
      $httpBackend = _$httpBackend_
      RelatedProposalsLoader = _RelatedProposalsLoader_

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should load list of RELATED proposals", ->
      $httpBackend.expectGET '/proposals/15/related_proposals?related_sort_by='
        .respond returnedProposalList

      expect RelatedProposalsLoader()
        .toBeDefined()

      $httpBackend.flush()

    it "should return a promise", ->
      $httpBackend.expectGET '/proposals/15/related_proposals?related_sort_by='
        .respond returnedProposalList

      promise = RelatedProposalsLoader()

      expect promise.then instanceof Object
        .toBeTruthy()

      $httpBackend.flush()

    it "should return an Object of Related Proposals via promise", ->
      $httpBackend.expectGET '/proposals/15/related_proposals?related_sort_by='
        .respond returnedProposalList

      promise = RelatedProposalsLoader()

      proposals = undefined
      promise.then (data) ->
        proposals = data

      $httpBackend.flush()

      expect proposals instanceof Object
        .toBeTruthy()
      expect proposals[0]
        .toEqual returnedProposalList[0]


    it "should reject the promise and respond with error", ->
      $httpBackend.expectGET '/proposals/15/related_proposals?related_sort_by='
        .respond 500

      promise = RelatedProposalsLoader()
      proposals = undefined

      promise.then (fruits) ->
        proposals = fruits
      , (reason) ->
        proposals = reason

      $httpBackend.flush()

      expect proposals
        .toContain 'Unable'


  describe "RelatedVoteInTreeLoader should load three proposals", ->
    RelatedVoteInTreeLoader = undefined

    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            proposalId: 15
#            hub: 1
#            filter: 'active'
#            user: 42

    beforeEach inject (_$httpBackend_, _RelatedVoteInTreeLoader_) ->
      $httpBackend = _$httpBackend_
      RelatedVoteInTreeLoader = _RelatedVoteInTreeLoader_

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should see Related VOTE IN TREE proposals defined", ->
      $httpBackend.expectGET '/proposals/17/related_vote_in_tree'
        .respond returnedProposalList

      expect RelatedVoteInTreeLoader clicked_proposal
        .toBeDefined()

      $httpBackend.flush()

    it "should return a promise", ->
      $httpBackend.expectGET '/proposals/17/related_vote_in_tree'
        .respond returnedProposalList

      promise = RelatedVoteInTreeLoader clicked_proposal

      expect promise.then instanceof Object
        .toBeTruthy()

      $httpBackend.flush()

    it "should return an Object of Related VOTE IN TREE via promise", ->
      $httpBackend.expectGET '/proposals/17/related_vote_in_tree'
        .respond returnedProposalList

      promise = RelatedVoteInTreeLoader clicked_proposal

      proposals = undefined
      promise.then (data) ->
        proposals = data

      $httpBackend.flush()

      expect proposals instanceof Object
        .toBeTruthy()
      expect proposals[0]
        .toEqual returnedProposalList[0]


    it "should reject the promise and respond with error", ->
      $httpBackend.expectGET '/proposals/17/related_vote_in_tree'
        .respond 500

      promise = RelatedVoteInTreeLoader clicked_proposal
      proposals = undefined

      promise.then (fruits) ->
        proposals = fruits
      , (reason) ->
        proposals = reason

      $httpBackend.flush()

      expect proposals
        .toContain 'Unable'
