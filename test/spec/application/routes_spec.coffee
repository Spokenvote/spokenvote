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

    it 'root path should map route to correct template and page title, but undefined callToAction, template, controller and summary', ->

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
        .toEqual 'Group Consensus Collaboration Tool'
      expect $rootScope.page.title
        .toEqual 'Group Consensus Collaboration Tool | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Your Group Decisions'
      expect $rootScope.page.summary
        .toBeUndefined()

    it '/landing path should map route to correct template and page title, but undefined callToAction, and template, but undefined controller and summary', ->

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
        .toEqual 'Group Consensus Voting Tool'
      expect $rootScope.page.title
        .toEqual 'Group Consensus Voting Tool | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Your Group Decisions'
      expect $rootScope.page.summary
        .toBeUndefined()

    it '/home path should map route to correct template and page title, but undefined callToAction, and template, but undefined controller and summary', ->

      $httpBackend.expectGET 'pages/landing.html'
        .respond 200
      $location.path '/home'
      $rootScope.$digest()

      expect $route.current.templateUrl
        .toBe 'pages/landing.html'
      expect $route.current.callToAction
        .toBe 'Your Decision Platform'
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual 'Decision Platform'
      expect $route.current.summary
        .toContain ' Spokenvote decision platform gives groups '
      expect $rootScope.page.title
        .toEqual 'Decision Platform | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Your Decision Platform'
      expect $rootScope.page.summary
        .toContain ' Spokenvote decision platform gives groups '

    it '/group-consensus-tool path should map route to correct template, page title, callToAction, and summary, but undefined controller', ->

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
      expect $route.current.summary
       .toContain ' group consensus tool gives groups '
      expect $rootScope.page.title
        .toEqual 'Group Consensus Tool | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Group Consensus Tool'
      expect $rootScope.page.summary
        .toContain ' group consensus tool gives groups '

    it '/online-group-consensus-tool path should map route to correct template, page title, callToAction, and summary, but undefined controller', ->

      $httpBackend.expectGET 'pages/landing.html'
        .respond 200
      $location.path '/online-group-consensus-tool'
      $rootScope.$digest()

      expect $route.current.templateUrl
        .toBe 'pages/landing.html'
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual 'Online Group Consensus Tool'
      expect $route.current.callToAction
        .toBe 'Online Group Consensus Tool'
      expect $route.current.summary
        .toContain ' Spokenvote online group consensus tool '
      expect $rootScope.page.title
        .toEqual 'Online Group Consensus Tool | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Online Group Consensus Tool'
      expect $rootScope.page.summary
        .toContain ' Spokenvote online group consensus tool '

    it '/voting-tool path should map route to correct template, page title, callToAction, and summary, but undefined controller', ->

      $httpBackend.expectGET 'pages/landing.html'
        .respond 200
      $location.path '/voting-tool'
      $rootScope.$digest()

      expect $route.current.templateUrl
        .toBe 'pages/landing.html'
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual 'Voting Tool'
      expect $route.current.callToAction
        .toBe 'Group Voting Tool'
      expect $route.current.summary
        .toContain ' group voting tool gives groups '
      expect $rootScope.page.title
        .toEqual 'Voting Tool | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Group Voting Tool'
      expect $rootScope.page.summary
        .toContain ' group voting tool gives groups '

    it '/reach-consensus path should map route to correct template, page title, callToAction, and summary, but undefined controller', ->

      $httpBackend.expectGET 'pages/landing.html'
        .respond 200
      $location.path '/reach-consensus'
      $rootScope.$digest()

      expect $route.current.templateUrl
        .toBe 'pages/landing.html'
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual 'Reach Consensus'
      expect $route.current.callToAction
        .toBe 'Reach Consensus'
      expect $route.current.summary
        .toContain 'Reach consensus quickly and efficiently. '
      expect $rootScope.page.title
        .toEqual 'Reach Consensus | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Reach Consensus'
      expect $rootScope.page.summary
        .toContain 'Reach consensus quickly and efficiently. '

    it '/group-consensus path should map route to correct template, page title, callToAction, and summary, but undefined controller', ->

      $httpBackend.expectGET 'pages/landing.html'
        .respond 200
      $location.path '/group-consensus'
      $rootScope.$digest()

      expect $route.current.templateUrl
        .toBe 'pages/landing.html'
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual 'Group Consensus'
      expect $route.current.callToAction
        .toBe 'Group Consensus'
      expect $route.current.summary
        .toContain 'Group consensus: quick and efficient. '
      expect $rootScope.page.title
        .toEqual 'Group Consensus | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual 'Group Consensus'
      expect $rootScope.page.summary
        .toContain 'Group consensus: quick and efficient. '

    it '/collaborative-decision path should map route to correct template, page title, callToAction, and summary, but undefined controller', ->

      $httpBackend.expectGET 'pages/landing.html'
        .respond 200
      $location.path '/collaborative-decision'
      $rootScope.$digest()

      pageTheme = 'Collaborative Decision'
      summaryTheme = 'Quick and efficient collaborative decisions. '

      expect $route.current.templateUrl
        .toBe 'pages/landing.html'
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual pageTheme
      expect $route.current.callToAction
        .toBe pageTheme
      expect $route.current.summary
        .toContain summaryTheme
      expect $rootScope.page.title
        .toEqual pageTheme + ' | Spokenvote'
      expect $rootScope.page.callToAction
        .toEqual pageTheme
      expect $rootScope.page.summary
        .toContain summaryTheme

    it 'bad urls should map route to page title, but undefined callToAction, template, and summary, but undefined controller', ->

      $location.path '/bad-url'
      $rootScope.$digest()

      expect $location.path()
        .toBe '/bad-url'
      expect $route.current.callToAction
        .toBe 'Group Consensus Tool'
      expect $route.current.templateUrl
        .toBeUndefined()
      expect $route.current.controller
        .toBeUndefined()
      expect $route.current.title
        .toEqual 'Lost in Space'
      expect $rootScope.page.title
        .toEqual 'Lost in Space | Group Consensus Tool | Spokenvote'
      expect $rootScope.page.summary
        .toContain ' group consensus tool gives groups '
