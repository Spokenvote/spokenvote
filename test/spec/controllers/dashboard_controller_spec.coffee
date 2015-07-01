describe 'Dashboard Controller Test', ->
  $rootScope = undefined
  $controller = undefined
  $httpBackend = undefined
  $location = undefined
  $timeout = undefined
  SessionSettings = undefined
  $provide = undefined

  beforeEach module 'spokenvote', 'spokenvoteMocks', (_$provide_) ->
    $provide = _$provide_
    -> $provide.value '$route'

  describe 'DashboardCtrl', ->
    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _$location_, _$timeout_, _SessionSettings_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $location = _$location_
      $timeout = _$timeout_
      $controller = _$controller_
      SessionSettings = _SessionSettings_

    it 'should have sessionSettings and tooltips defined', ->
      $provide.value '$route',
        current:
          params: {}
      $rootScope.sessionSettings = SessionSettings
      $scope = $rootScope.$new()
      $controller "DashboardCtrl",
        $scope: $scope
      $scope.$apply()
      expect $scope.sessionSettings
        .toBeDefined()
      expect $scope.tooltips
        .toBeDefined()


    describe 'Prerender logic should initialize properly', ->

      it 'should find $scope.route.current.prerenderStatusCode and it should be undefined', ->
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $scope.$apply()
        expect $scope.route.current.prerenderStatusCode
        .toEqual undefined

      it 'should find $scope.route.current.prerenderStatusCode and it should be defined', ->
        $provide.value '$route',
          current:
            params: {}
            prerenderStatusCode: '404'
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
        $scope.$apply()
        expect $scope.route.current.prerenderStatusCode
          .toBeDefined()
        expect $scope.route.current.prerenderStatusCode
          .toEqual '404'

      it 'should not find $scope.route.current.prerenderStatusCode', ->
        $httpBackend.expectGET '/hubs/2'
          .respond '200', 'hub1'
        $provide.value '$route',
          current:
            params:
              hub: '2'
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
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


    describe 'Page Meta Descriptions initialize properly', ->

      it 'should find $scope.page.metaDescription and it should be Undefined', ->
        $provide.value '$route',
          current:
            params: {}
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
        $scope.$apply()
        expect $scope.page.metaDescription
          .toBeUndefined()

      it 'should find $scope.page.metaDescription and it should contain Active', ->
        $provide.value '$route',
          current:
            params:
              filter: 'active'
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
        $scope.$apply()
        expect $scope.page.metaDescription
          .toBeDefined()
        expect $scope.page.metaDescription
          .toContain 'Active'

      it 'should find $scope.page.metaDescription and it should contain Recent', ->
        $provide.value '$route',
          current:
            params:
              filter: 'recent'
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
        $scope.$apply()
        expect $scope.page.metaDescription
          .toBeDefined()
        expect $scope.page.metaDescription
          .toContain 'Recent'

      it 'should find $scope.page.metaDescription and it should contain My', ->
        $provide.value '$route',
          current:
            params:
              filter: 'my'
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
        $scope.$apply()
        expect $scope.page.metaDescription
          .toBeDefined()
        expect $scope.page.metaDescription
          .toContain 'My'

      it 'should find $scope.page.metaDescription and it should be null after timeout', ->
        $provide.value '$route',
          current:
            params:
              filter: 'my'
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
        $scope.$apply()

        $timeout.flush()

        expect $scope.page.metaDescription
          .toEqual null


    describe 'Moving off of Start Proposal page logic should respond correctly', ->

      it 'should not initialize if still on start page', ->
        route =
          current:
            params: {}
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
          $route: route
        $scope.sessionSettings.actions.hubShow = false
        $scope.sessionSettings.actions.hubSeekOnSearch = false
        $scope.sessionSettings.actions.hubPlaceholder = 'Set your Group for the new proposal ...'
        $scope.sessionSettings.hub_attributes =
          full_hub:'Some great hub'
          isTag: true

        $location.path '/start'
        $rootScope.$broadcast '$locationChangeSuccess', 'goodUrl', 'oldUrl'

        expect $scope.sessionSettings.actions.hubShow
          .toEqual false
        expect $scope.sessionSettings.actions.hubSeekOnSearch
          .toEqual false
        expect $scope.sessionSettings.actions.hubPlaceholder
          .toContain 'Set your Group'
        expect $scope.sessionSettings.hub_attributes.full_hub
          .toContain 'Some great hub'

      it 'should initialize if leaving start page', ->
        route =
          current:
            params: {}
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
          $route: route
        $scope.sessionSettings.actions.hubShow = false
        $scope.sessionSettings.actions.hubSeekOnSearch = false
        $scope.sessionSettings.actions.hubPlaceholder = 'Set your Group for the new proposal ...'
        $scope.sessionSettings.hub_attributes =
          full_hub:'Some great hub'
          isTag: true

        $location.path '/landing'
        $rootScope.$broadcast '$locationChangeSuccess', '/start', 'oldUrl'

        expect $scope.sessionSettings.actions.hubShow
          .toEqual true
        expect $scope.sessionSettings.actions.hubSeekOnSearch
          .toEqual true
        expect $scope.sessionSettings.actions.hubPlaceholder
          .toContain 'Search to find your Group ...'
        expect $scope.sessionSettings.hub_attributes
          .toEqual null

      it 'should keep hub if NOT a Tag', ->
        route =
          current:
            params: {}
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
          $route: route
        $scope.sessionSettings.actions.hubShow = false
        $scope.sessionSettings.actions.hubSeekOnSearch = false
        $scope.sessionSettings.actions.hubPlaceholder = 'Set your Group for the new proposal ...'
        $scope.sessionSettings.hub_attributes =
          full_hub:'Some great hub'

        $location.path '/landing'
        $rootScope.$broadcast '$locationChangeSuccess', '/start', 'oldUrl'

#        expect $scope.sessionSettings.actions.hubShow
#          .toEqual true
#        expect $scope.sessionSettings.actions.hubSeekOnSearch
#          .toEqual true
#        expect $scope.sessionSettings.actions.hubPlaceholder
#          .toContain 'Search to find your Group ...'
        expect $scope.sessionSettings.hub_attributes.full_hub
          .toEqual 'Some great hub'


    describe 'Scope functions should initialize and function', ->

      it 'should have $scope.landing defined', ->
        $provide.value '$route',
          current:
            params: {}
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
        $scope.$apply()
        expect $scope.landing
         .toBeDefined()

        $scope.sessionSettings.hub_attributes =
          full_hub:'Some great hub'
        $location.url '/start'

        $scope.landing()

        expect $location.path()
          .toEqual '/landing'
        expect $scope.sessionSettings.hub_attributes
          .toEqual null

        $scope.sessionSettings.hub_attributes =
          full_hub:'Some great hub'
        $location.url '/start?hub=6&filter=my'

        $scope.landing()

        expect $location.url()
          .toEqual '/landing?hub=6&filter=my'
        expect $scope.sessionSettings.hub_attributes
          .toEqual null

      it 'should have $scope.hubSearch defined', ->
        $provide.value '$route',
          current:
            params: {}
        $rootScope.sessionSettings = SessionSettings
        $scope = $rootScope.$new()
        $controller "DashboardCtrl",
          $scope: $scope
        $scope.$apply()
        expect $scope.hubSearch
         .toBeDefined()

        $scope.sessionSettings.actions =
          hubShow: false
          hubSeekOnSearch: false
          hubPlaceholder: undefined

        $scope.hubSearch()

        expect $scope.sessionSettings.actions.hubShow
          .toEqual true
        expect $scope.sessionSettings.actions.hubSeekOnSearch
          .toEqual true
        expect $scope.sessionSettings.actions.hubPlaceholder
          .toContain 'Search to find'





