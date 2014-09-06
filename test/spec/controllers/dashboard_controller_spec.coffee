describe "Dashboard Controller Test", ->
  $scope = undefined
  ctrl = undefined
  $location = undefined
  $httpBackend = undefined
  $route = undefined
  provide = undefined
  $controller = undefined
#  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'

  beforeEach module 'spokenvote', 'spokenvoteMocks', ($provide) ->
    provide = $provide
    -> $provide.value '$route', {}

  describe "DashboardCtrl", ->
    beforeEach inject ($rootScope, _$controller_, _$httpBackend_, _$location_, SessionSettings) ->
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
#      provide.value '$route',
#        current:
#          params: {}
      $location = _$location_
      $httpBackend = _$httpBackend_
      $controller = _$controller_
#      ctrl = $controller "DashboardCtrl",
#        $scope: $scope

    it 'should have sessionSettings defined', ->
      provide.value '$route',
        current:
          params: {}
      ctrl = $controller "DashboardCtrl",
        $scope: $scope

      expect $scope.sessionSettings
        .toBeDefined()

    it 'should find $scope.route.current.prerenderStatusCode and it should be defined', ->
      expect $scope.route.current.prerenderStatusCode
        .toBeUndefined()

    it 'should not find $scope.route.current.prerenderStatusCode', ->
      $httpBackend.expectGET '/hubs/2'
        .respond '200', 'hub1'
      provide.value '$route',
        current:
          prerenderStatusCode: '404'
          params:
            hub: '2'
      ctrl = $controller "DashboardCtrl",
        $scope: $scope
      $scope.$apply()
#      $httpBackend.flush()
      expect $scope.route.current.prerenderStatusCode
        .toBeUndefined

    it 'should find $scope.route.current.prerenderStatusCode and it should equal 404', ->
      provide.value '$route',
        current:
          prerenderStatusCode: '404'
          params: {}
      ctrl = $controller "DashboardCtrl",
        $scope: $scope
#      $location.path('/some-bad-url')  # Does not seem to trigger route action
      $scope.$apply()
      expect($scope.route.current.prerenderStatusCode).toEqual('404')
