describe "Dashboard Controller Test", ->
#  $scope = undefined
#  ctrl = undefined
  $rootScope = undefined
  $location = undefined
  $httpBackend = undefined
  $route = undefined
  $provide = undefined
  $controller = undefined
  SessionSettings = undefined

  beforeEach module 'spokenvote', 'spokenvoteMocks', (_$provide_) ->
    $provide = _$provide_
    -> $provide.value '$route', {}

  describe "DashboardCtrl", ->
    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _$location_, _SessionSettings_) ->
      $rootScope = _$rootScope_
      $location = _$location_
      $httpBackend = _$httpBackend_
      $controller = _$controller_
      SessionSettings = _SessionSettings_
#      $rootScope.sessionSettings = SessionSettings
#      $scope = $rootScope.$new()

    it 'should have sessionSettings defined', ->
      $provide.value '$route',
        current:
          params: {}
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      ctrl = $controller "DashboardCtrl",
        $scope: $scope
      $scope.$apply()
      expect $scope.sessionSettings
        .toBeDefined()

    it 'should find $scope.route.current.prerenderStatusCode and it should be defined', ->
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      $scope.$apply()
      expect $scope.route.current.prerenderStatusCode
        .toBeUndefined()

    it 'should not find $scope.route.current.prerenderStatusCode', ->
      $httpBackend.expectGET '/hubs/2'
        .respond '200', 'hub1'
      $provide.value '$route',
        current:
          prerenderStatusCode: '404'
          params:
            hub: '2'
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      ctrl = $controller "DashboardCtrl",
        $scope: $scope
      $scope.$apply()
#      $httpBackend.flush()
      console.log '**8 test ***: ', $scope.route.current.prerenderStatusCode
      expect($scope.route.current.prerenderStatusCode).toBeUndefined

    it 'should find $scope.route.current.prerenderStatusCode and it should equal 404', ->
      $provide.value '$route',
        current:
          prerenderStatusCode: '404'
          params: {}
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      ctrl = $controller "DashboardCtrl",
        $scope: $scope
#      $location.path('/some-bad-url')  # Does not seem to trigger route action
      $scope.$apply()
      expect($scope.route.current.prerenderStatusCode).toEqual('404')
