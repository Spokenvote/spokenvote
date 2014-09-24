describe 'Routes Tests', ->
  $route = undefined
  $rootScope = undefined
  $controller = undefined
  $httpBackend = undefined
  $location = undefined
  SessionSettings = undefined

  beforeEach module 'spokenvote', 'spokenvoteMocks'

  describe 'Router Testing', ->
    beforeEach inject (_$route_, _$rootScope_, _$controller_, _$httpBackend_, _$location_, _SessionSettings_) ->
      $route = _$route_
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $location = _$location_
      $controller = _$controller_
      SessionSettings = _SessionSettings_

    it 'should map routes to templates, callToAction, controllers, rootscope page titles, and rootscope callToAction', ->
      expect $route.routes['/'].controller
        .toBeUndefined()
      expect $route.routes["/"].templateUrl
        .toEqual 'pages/landing.html'
      expect $route.routes['/landing'].controller
      .toBeUndefined()

#      # otherwise redirect to
#      expect($route.routes[null].redirectTo).toEqual "/phones"

      expect $route.current
        .toBeUndefined()

      $httpBackend.expectGET 'pages/landing.html'
        .respond 200
      $location.path '/'
      $rootScope.$digest()

      expect $route.current.templateUrl
        .toBe 'pages/landing.html'
      expect $route.current.callToAction
        .toBe 'Your Group Decisions'
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual 'Online Group Consensus Tool'
      expect $rootScope.page.title
        .toEqual 'Online Group Consensus Tool | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Your Group Decisions'

      $location.path '/otherwise'
      $rootScope.$digest()

      expect $location.path()
        .toBe '/otherwise'
      expect $route.current.templateUrl
        .toBeUndefined()
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual 'Lost in Space'
      expect $rootScope.page.title
        .toEqual 'Lost in Space | Online Group Consensus Tool | Spokenvote'