describe 'Routes Tests', ->
  $route = undefined
  $rootScope = undefined
  $httpBackend = undefined
  $location = undefined
#  $controller = undefined
#  SessionSettings = undefined

  beforeEach module 'spokenvote', 'spokenvoteMocks'

  describe 'Injecting $ route into Router Testing', ->
    beforeEach inject (_$route_, _$rootScope_, _$httpBackend_, _$location_) ->
      $route = _$route_
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $location = _$location_
#      $controller = _$controller_
#      SessionSettings = _SessionSettings_

    it 'routes should start out undefined', ->

      expect $route.current
        .toBeUndefined()

    it 'root path should map route to correct template, callToAction, controller, rootscope page title and rootscope callToAction', ->

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
        .toEqual 'Group Consensus Tool'
      expect $rootScope.page.title
        .toEqual 'Group Consensus Tool | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Your Group Decisions'

    it '/landing path should map route to correct template, callToAction, controller, rootscope page title and rootscope callToAction', ->

      $httpBackend.expectGET 'pages/landing.html'
        .respond 200
      $location.path '/landing'
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

    it '/group-consensus-tool path should map route to correct template, callToAction, controller, rootscope page title and rootscope callToAction', ->

      $httpBackend.expectGET 'pages/landing.html'
        .respond 200
      $location.path '/group-consensus-tool'
      $rootScope.$digest()

      expect $route.current.templateUrl
        .toBe 'pages/landing.html'
      expect $route.current.callToAction
        .toBe 'Group Consensus Tool'
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual 'Group Consensus Tool'
      expect $rootScope.page.title
        .toEqual 'Group Consensus Tool | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Group Consensus Tool'

    it 'bad urls should map route to rootscope page title, but undefined callToAction, template and controller', ->

      $location.path '/bad-url'
      $rootScope.$digest()

      expect $location.path()
        .toBe '/bad-url'
      expect $route.current.callToAction
        .toBeUndefined()
      expect $route.current.templateUrl
        .toBeUndefined()
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual 'Lost in Space'
      expect $rootScope.page.title
        .toEqual 'Lost in Space | Online Group Consensus Tool | Spokenvote'
