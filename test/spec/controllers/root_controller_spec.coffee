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
      $controller = _$controller_
      SessionSettings = _SessionSettings_

    it 'should place sessionSettings on the rootScope', ->
      $httpBackend.expectGET endpoint
        .respond '200'
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
