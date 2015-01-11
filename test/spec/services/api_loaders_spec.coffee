describe "API Test", ->
#  $scope = undefined
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
      currentHubLoader = CurrentHubLoader
      $httpBackend = _$httpBackend_

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it "should load the current hub", ->
      $httpBackend.expectGET '/hubs/1'
        .respond {"id":1,"group_name":"Hacker Dojo","description":"Hacker Dojo","created_at":"2013-02-10T00:01:58.914Z","updated_at":"2013-02-10T00:01:58.914Z","location_id":"bb51f066ff3fd0b033db94b4e6172da84b8ae111","formatted_location":"Mountain View, CA","full_hub":"Hacker Dojo - Mountain View, CA","short_hub":"Hacker Dojo","select_id":1}

      promise = currentHubLoader()
      hub = undefined

      promise.then (data) ->
        hub = data

      $httpBackend.flush()

      expect hub instanceof Object
        .toBeTruthy()
      expect(hub).toEqual jasmine.objectContaining {"id":1,"group_name":"Hacker Dojo","description":"Hacker Dojo","created_at":"2013-02-10T00:01:58.914Z","updated_at":"2013-02-10T00:01:58.914Z","location_id":"bb51f066ff3fd0b033db94b4e6172da84b8ae111","formatted_location":"Mountain View, CA","full_hub":"Hacker Dojo - Mountain View, CA","short_hub":"Hacker Dojo","select_id":1}


  describe "ProposalLoader should load a proposal", ->
    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            proposalId: 23

    beforeEach inject (_$httpBackend_, $rootScope, $controller, SessionSettings, ProposalLoader) ->
      proposalLoader = ProposalLoader
      $httpBackend = _$httpBackend_

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
      expect(proposal).toEqual jasmine.objectContaining {"id":23,"statement":"Hacker Dojo should organize an annual startup launch event","user_id":43,"created_at":"2013-02-10 05:02:39 UTC"}

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
    beforeEach module ($provide) ->
      -> $provide.value '$route',
        current:
          params:
            hub: 1
            filter: 'active'
            user: 42

    beforeEach inject (_$httpBackend_, $rootScope, $controller, SessionSettings, MultiProposalLoader) ->
      multiProposalLoader = MultiProposalLoader
      $httpBackend = _$httpBackend_

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
      expect(proposals).toEqual [ "id":23,"statement 23":"Hacker Dojo", "id":24,"statement24":"Hacker Dojo", "id":25,"statement 25":"Hacker Dojo" ]


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
