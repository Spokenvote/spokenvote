describe "Controllers Test", ->
  $scope = undefined
  ctrl = undefined
  rootScope = undefined
  multiProposalLoader = undefined
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'

  beforeEach module ($provide) ->
    ->
      $provide.value '$route',
        current:
          params:
            hub: 1
            filter: 'active'
            user: 42

#  beforeEach ->
#    @addMatchers toEqualData: (expected) ->
#      angular.equals @actual, expected

  describe "Initial Validation Test", ->
    it "should match", ->
      expect("string").toMatch new RegExp("^string$")

  describe "MultiProposalLoader", ->
    $httpBackend = undefined
    proposal = undefined
    loader = undefined
#    $scope = undefined
    routeParams = undefined

    beforeEach inject (_$httpBackend_, $location, $rootScope, $controller, SessionSettings, MultiProposalLoader) ->
      routeParams = {}
      routeParams.hub = 1
      routeParams.filter = 'active'
      routeParams.user = 42
      $rootScope.sessionSettings = SessionSettings
      rootScope = $rootScope
#      $scope.proposals = {}

      multiProposalLoader = MultiProposalLoader
      $httpBackend = _$httpBackend_

#      $httpBackend.expectGET('/proposals?filter=active&hub=1&user=42')
#      $httpBackend.whenGET('/proposals?filter=active&hub=1&user=42')
#        .respond([ 1, 2, 3 ])
      $scope = $rootScope.$new()
#      ctrl = $controller "ProposalListCtrl",
#        $scope: $scope

#      proposal = Proposal
#      loader = MultiProposalLoader

#      $location.path('/proposals')
#      $location.search('hub', 1)
#      $location.search('filter', 'active')
#      $location.search('user', 42)

#      afterEach ->
#        $httpBackend.verifyNoOutstandingExpectation()
#        $httpBackend.verifyNoOutstandingRequest()

    it "should load list of proposals", ->
      $httpBackend.whenGET('/proposals?filter=active&hub=1&user=42')
#      $httpBackend.expectGET('/proposals?filter=active&hub=1&user=42')
        .respond([ 1, 2, 3 ])

      expect($scope.proposals).toBeUndefined()
      expect(multiProposalLoader()).toBeDefined()

      promise = multiProposalLoader()
      proposals = undefined
#      console.log 'promise: ', promise
      promise.then (data) ->
        proposals = data
        console.log 'proposals: ', proposals

      # Simulate a server response
      $httpBackend.flush()
      expect(proposals instanceof Array).toBeTruthy()



#      spyOn(MultiProposalLoader, '@delay').andCallThrough()
      #      scope.init()
      #      deferred.resolve()
      #      scope.$root.$digest()
#      expect(MultiProposalLoader().then).toHaveBeenCalled()
#      $scope.proposals.then()
#      $scope.$digest()
#      $scope.proposals.$promise.then (data) ->
#        console.log '$scope.proposals in test: ', data
#        console.log 'data: ', $scope.proposals
#      console.log '$scope.proposals in test: ', $scope.proposals.$promise.then
#      $scope.proposals.forEach (p) ->
#        console.log '$scope.proposals in test[0]: ', p.$get()
#      expect($scope.proposals instanceof Array).toBeTruthy()
#      expect($scope.proposals).toContain([ 1, 2, 3 ])
#      expect($scope.proposals).toEqual([ 1, 2, 3 ])
#        id: 1
#      ,
#        id: 2
#      ]

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
