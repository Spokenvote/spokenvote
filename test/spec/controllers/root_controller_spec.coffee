describe 'Root Controller Test', ->
  $rootScope = undefined
  $controller = undefined
  $httpBackend = undefined
  $location = undefined
  SessionSettings = undefined
  $provide = undefined
  endpoint = '/currentuser'

  beforeEach module 'spokenvote', 'spokenvoteMocks', (_$provide_) ->
    $provide = _$provide_
    -> $provide.value '$route'

  describe "RootCtrl", ->
    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _$location_, _SessionSettings_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $location = _$location_
#      $route = _$route_
      $controller = _$controller_
      SessionSettings = _SessionSettings_

    it 'should place sessionSettings on the rootScope', ->
      $httpBackend.expectGET '/currentuser'
        .respond '200'
      #      $provide.value '$route',
#        current:
#          params: {}
#      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      $controller "RootCtrl",
        $scope: $scope
      $scope.$apply()

      expect $scope.sessionSettings
        .toBeDefined()

    it 'window.prerenderReady should be true after AJAX call is complete', ->
      $httpBackend.expectGET endpoint
        .respond 200
      $scope = $rootScope.$new()
      $controller "RootCtrl",
        $scope: $scope
      $httpBackend.flush()

      expect window.prerenderReady
        .toBe true

    it 'should find $scope.route.current.prerenderStatusCode and it should be defined', ->          #dupe from dashbard_controller_spec
#      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      $scope.$apply()
      expect $scope.route.current.prerenderStatusCode
        .toEqual undefined

    it 'should not find $scope.route.current.prerenderStatusCode', ->
      $httpBackend.expectGET '/currentuser'
        .respond '200'
#      $provide.value '$route',
#        current:
#          params:
#            hub: '2'
#      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      ctrl = $controller "RootCtrl",
        $scope: $scope
      $httpBackend.flush()
      expect $scope.route.current.prerenderStatusCode
        .toEqual undefined

    route = undefined
    $scope = undefined

    it 'should find $scope..prerenderStatusCode to be undefined', ->
      route =
        current:
          params: {}
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      $controller "DashboardCtrl",
        $scope: $scope
        $route: route
      $rootScope.$broadcast('$locationChangeSuccess', 'goodUrl', 'oldUrl')
      expect $scope.route.current.prerenderStatusCode
        .toEqual undefined

    it 'should find $scope..prerenderStatusCode to be equal 404', ->
      route.current.prerenderStatusCode = '404'
      $scope.$apply()
      expect $scope.route.current.prerenderStatusCode
        .toEqual '404'
