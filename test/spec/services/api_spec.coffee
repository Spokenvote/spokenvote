describe "API Test", ->
#  $scope = undefined
#  rootScope = undefined
  $httpBackend = undefined
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

  beforeEach ->
    @addMatchers toEqualData: (expected) ->
      angular.equals @actual, expected

  describe "Initial Validation Test", ->
    it "should match", ->
      expect("string").toMatch new RegExp("^string$")

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