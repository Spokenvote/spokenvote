describe "Dashboard Controller Test", ->
  $rootScope = undefined
  $controller = undefined
  $httpBackend = undefined
  $location = undefined
  route = undefined
  SessionSettings = undefined
  $provide = undefined

  beforeEach module 'spokenvote', 'spokenvoteMocks', (_$provide_) ->
    $provide = _$provide_
    -> $provide.value '$route'

  describe "DashboardCtrl", ->
    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _$location_, _SessionSettings_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $location = _$location_
#      $route = _$route_
      $controller = _$controller_
      SessionSettings = _SessionSettings_

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
        .toEqual undefined

    it 'should not find $scope.route.current.prerenderStatusCode', ->
      $httpBackend.expectGET '/hubs/2'
        .respond '200', 'hub1'
      $provide.value '$route',
        current:
          params:
            hub: '2'
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      ctrl = $controller "DashboardCtrl",
        $scope: $scope
      $httpBackend.flush()
      expect $scope.route.current.prerenderStatusCode
        .toEqual undefined

#  describe "DashboardCtrl", ->
#    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _$location_, _SessionSettings_) ->
#      $rootScope = _$rootScope_
#      $httpBackend = _$httpBackend_
#      $location = _$location_
##      route = _$route_
#      $controller = _$controller_
#      SessionSettings = _SessionSettings_

    it 'should find $scope.route.current.prerenderStatusCode and it should equal 404', ->
      console.log 'find code: '
      route =
        current:
#          prerenderStatusCode: '404'
          params: {}
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      $controller "DashboardCtrl",
        $scope: $scope
        $route: route
      route =
        current:
          prerenderStatusCode: '404'
          params: {}
      $rootScope.$broadcast('$locationChangeSuccess', 'newUrl', 'oldUrl')

      console.log 'location change in test: '
#      console.log 'route: ', route
      $location.path('/some-bad-url')  # Does not seem to trigger route action
#      locRoute =
#        current:
#          prerenderStatusCode: '404'
#          params: {}
#      eachArray = _.toArray($scope)
#      eachArray.forEach (e) ->
#        console.log 'e: ', e
      $scope.$apply()
#      $scope.$digest()
      expect $scope.route.current.prerenderStatusCode
        .toEqual '404'
