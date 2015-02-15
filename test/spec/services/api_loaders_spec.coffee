describe "API Test", ->
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'
  $httpBackend = undefined

  describe "CurrentHubLoader should respond to requests", ->
    currentHubLoader = undefined

    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            hub: 1
            filter: 'active'
            user: 42

    beforeEach inject (_$httpBackend_, CurrentHubLoader) ->
      $httpBackend = _$httpBackend_
      currentHubLoader = CurrentHubLoader

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "CurrentHubLoader should load the current hub", ->
      $httpBackend.expectGET '/hubs/1'
        .respond {"id":1,"group_name":"Hacker Dojo","description":"Hacker Dojo","created_at":"2013-02-10T00:01:58.914Z","updated_at":"2013-02-10T00:01:58.914Z"}

      promise = currentHubLoader()
      hub = undefined

      promise.then (data) ->
        hub = data

      $httpBackend.flush()

      expect hub instanceof Object
        .toBeTruthy()
      expect hub
        .toEqual jasmine.objectContaining {"id":1,"group_name":"Hacker Dojo","description":"Hacker Dojo","created_at":"2013-02-10T00:01:58.914Z","updated_at":"2013-02-10T00:01:58.914Z"}

    it "CurrentHubLoader should return a promise", ->
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


  describe "SelectHubLoader should respond to requests", ->
    selectHubLoader = undefined

    beforeEach inject (_$httpBackend_, SelectHubLoader) ->
      $httpBackend = _$httpBackend_
      selectHubLoader = SelectHubLoader

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "CurrentHubLoader should load the current hub", ->
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

    it "SelectHubLoader should return a promise", ->
      $httpBackend.expectGET '/hubs?hub_filter=ha'
      .respond [ {"id":1,"group_name":"Hacker Dojo"}, {"id":321,"group_name":"Hacker Doggies"}, {"id":676,"group_name":"Hacker Dummies"} ]

      hub_filter = 'ha'
      promise = selectHubLoader(hub_filter)

      promise.then (data) ->
        hub = data

      $httpBackend.flush()

    it "SelectHubLoader should reject the promise and respond with error", ->
      $httpBackend.expectGET '/hubs?hub_filter=ha'
      .respond 500

      hub_filter = 'ha'
      promise = selectHubLoader(hub_filter)
      proposal = undefined

      promise.then (fruits) ->
        proposal = fruits
      , (reason) ->
        proposal = reason

      $httpBackend.flush()

      expect proposal
      .toContain 'Unable'


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

    it "ProposalLoader should return a promise", ->
      $httpBackend.expectGET '/proposals/23'
        .respond {"id":23,"statement":"Hacker Dojo should organize an annual startup launch event","user_id":43,"created_at":"2013-02-10 05:02:39 UTC"}

      promise = proposalLoader()

      promise.then (data) ->
        proposals = data

      $httpBackend.flush()

    it "ProposalLoader promise should return a proposal", ->
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

    it "MultiProposalLoader should return a promise", ->
      $httpBackend.expectGET '/proposals?filter=active&hub=1&user=42'
        .respond [ "id":23,"statement 23":"Hacker Dojo", "id":24,"statement24":"Hacker Dojo", "id":25,"statement 25":"Hacker Dojo" ]

      promise = multiProposalLoader()

      expect promise.then instanceof Object
        .toBeTruthy()

      $httpBackend.flush()

    it "MultiProposalLoader promise should return an array", ->
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
