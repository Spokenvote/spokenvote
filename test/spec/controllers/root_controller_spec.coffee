describe 'Root Controller Test', ->
  $rootScope = undefined
  $scope = undefined
  $controller = undefined
  $httpBackend = undefined
  $location = undefined
  $timeout = undefined
  SessionSettings = undefined
  $provide = undefined
  endpoint = '/currentuser'
  promise = undefined

  current_user =
    id: 44
    email: "termmonitor@gmail.com"
    name: "Kim Miller"
    username: "Kim Miller"
    first_name: "Kim"
    facebook_auth:  "1014514417"
    gravatar_hash:  "bbd5398ccde904d92ba0d5b8fc6c7344"
    'is_admin?': false

  beforeEach module 'spokenvote', 'spokenvoteMocks', (_$provide_) ->
    $provide = _$provide_
    -> $provide.value '$route'

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe "RootCtrl", ->
    beforeEach inject (_$rootScope_, _$controller_, _$httpBackend_, _$location_, _$timeout_, _SessionSettings_) ->
      $rootScope = _$rootScope_
      $httpBackend = _$httpBackend_
      $location = _$location_
      $controller = _$controller_
      $timeout = _$timeout_
      SessionSettings = _SessionSettings_

#      spyOn($scope, '$broadcast').and.callThrough()
#      $rootScope.authService =
      #        signinFb: jasmine.createSpy('authService').and.returnValue promise
#      promise =
#        then: -> 'jasmine.createSpy()'
#      CurrentUserLoader =
#        jasmine.createSpy('currentUserLoader')
#          .and.returnValue promise
#      $rootScope.votingService =
#        support: jasmine.createSpy('votingService:support')
#        improve: jasmine.createSpy('votingService:improve')
#        edit: jasmine.createSpy('votingService:edit')
#        delete: jasmine.createSpy('votingService:delete')

      $scope = $rootScope.$new()
      $controller "RootCtrl",
        $scope: $scope
#        CurrentUserLoader: CurrentUserLoader

      $httpBackend.expectGET endpoint
        .respond '200', current_user
      $httpBackend.flush()
#      $scope.$apply()

    it 'should place initial Objects on the RootScope', ->

      expect $scope.alertService
        .toBeDefined()
      expect $scope.authService
        .toBeDefined()
      expect $scope.sessionSettings
        .toBeDefined()
      expect $scope.votingService
        .toBeDefined()

    it 'Current User should load', ->

#      promise = $scope.currentUser

#      proposal = undefined
#      promise.then (data) ->
#        $scope.currentUser = data

#      $httpBackend.flush()
#      $httpBackend.expectGET endpoint
#        .respond 200, current_user
#      $scope = $rootScope.$new()
#      $controller "RootCtrl",
#        $scope: $scope
#      $scope.$apply()
#      console.log '$scope.currentUser in test: ', $scope.currentUser       # TODO Have not yet figured out promises in this context
      expect $scope.currentUser
        .toBeDefined()
#      expect $scope.currentUser
#        .toEqual current_user


    it 'window.prerenderReady should be true after AJAX call is complete', ->
      $httpBackend.expectGET endpoint
        .respond 200
      $scope = $rootScope.$new()
      $controller "RootCtrl",
        $scope: $scope
      $httpBackend.flush()

      expect window.prerenderReady
        .toBe true

    it 'window.prerenderReady should be true after timeout', ->
      $httpBackend.expectGET endpoint
        .respond '200'
      $scope = $rootScope.$new()
      $controller 'RootCtrl',
        $scope: $scope
      $httpBackend.flush()

      window.prerenderReady = false     # Manually set to false so the timeout can set it back to true and test will be valid
      $timeout.flush()

      expect window.prerenderReady
        .toBe true

