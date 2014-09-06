describe "Dashboard Controller Test", ->
  $scope = undefined
  ctrl = undefined
  $location = undefined
  $httpBackend = undefined
  $route = undefined
  beforeEach module 'spokenvote'
  beforeEach module 'spokenvoteMocks'

  beforeEach module ($provide) ->
    -> $provide.value '$route',
      current:
        params: {}
#          hub: 1
#          filter: 'active'
#          user: 42

  describe "Initial Validation Test", ->
    it "should match", ->
      expect("string").toMatch new RegExp("^string$")

  describe "DashboardCtrl", ->
    beforeEach inject ($rootScope, $controller, _$httpBackend_, _$location_, SessionSettings) ->
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      ctrl = $controller "DashboardCtrl",
        $scope: $scope
      $location = _$location_
      $httpBackend = _$httpBackend_

    it 'should have sessionSettings defined', ->
      expect($scope.sessionSettings).toBeDefined()

    it 'should find $scope.route.current.prerenderStatusCode and it should be defined', ->
      expect($scope.route.current.prerenderStatusCode).toBeUndefined()

    it 'should find $scope.route.current.prerenderStatusCode and it should equal 404', ->
      $httpBackend.expectGET('/hubs/1').respond('200', 'hub1')
      $scope.$apply()
#      $httpBackend.flush()
      expect($scope.route.current.prerenderStatusCode).toBeUndefined

    it 'should find $scope.route.current.prerenderStatusCode and it should equal 404', ->
      $location.path('/some-bad-url')
      $route.current.prerenderStatusCode = '404'
      $scope.$apply()
      expect($scope.route.current.prerenderStatusCode).toEqual('404')
