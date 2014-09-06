describe "Dashboard Controller Test", ->
  $scope = undefined
  ctrl = undefined
  location = undefined
  beforeEach module 'spokenvote'
  beforeEach module 'spokenvoteMocks'

  beforeEach module ($provide) ->
    -> $provide.value '$route',
      current:
        params:
          hub: 1
          filter: 'active'
          user: 42

  describe "Initial Validation Test", ->
    it "should match", ->
      expect("string").toMatch new RegExp("^string$")

  describe "DashboardCtrl", ->
    beforeEach inject ($rootScope, $controller, _$httpBackend_, $location, SessionSettings) ->
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      ctrl = $controller "DashboardCtrl",
        $scope: $scope
      location = $location

    it 'should have sessionSettings defined', ->
      expect($scope.sessionSettings).toBeDefined()

    it 'should find $scope.route.current.prerenderStatusCode and it should be defined', ->
      expect($scope.route.current.prerenderStatusCode).toBeUndefined()

    location.path('/proposals')

    it 'should find $scope.route.current.prerenderStatusCode and it should be defined', ->
      expect($scope.route.current.prerenderStatusCode).toBeUndefined()
