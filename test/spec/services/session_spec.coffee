describe "Session Service Test", ->

  $http = null
  $httpBackend = null
# $document = $timeout = result = loadingBar = null
  $rootScope = null

  endpoint = '/service'

  beforeEach ->
    module 'spokenvote'

    inject (_$http_, _$httpBackend_, _$document_, _$timeout_, _$rootScope_) ->
      $http = _$http_
      $httpBackend = _$httpBackend_
  #    $document = _$document_
  #    $timeout = _$timeout_
      $rootScope = _$rootScope_

  describe 'Intercepter (errorHttpInterceptor) Test', ->
    it 'should set error to AlertService.alertMessage on 401 server response', inject ( AlertService ) ->
      $httpBackend.expectGET endpoint
        .respond 401

      $http.get endpoint
      $httpBackend.flush()

      expect AlertService.alertMessage
        .toContain 'server was unable'


    it 'should set error message to AlertService.alertMessage on 500 server response', inject ( AlertService ) ->
      $httpBackend.expectGET endpoint
        .respond 499

      $http.get endpoint
      $httpBackend.flush()

      expect AlertService.alertMessage
        .toContain 'server was unable'

    it 'should set sign in message to AlertService.alertMessage on 406 server response', inject ( AlertService ) ->
      $httpBackend.expectGET endpoint
        .respond 406

      $http.get endpoint
      $httpBackend.flush()

      expect AlertService.alertMessage
        .toContain 'Please sign in'

    it 'should broadcast event:loginRequired on 406 server response', inject ( AlertService ) ->
      $httpBackend.expectGET endpoint
        .respond 406

      loginRequired = false

      $rootScope.$on 'event:loginRequired', (event) ->
        loginRequired = true

      $http.get endpoint
      $httpBackend.flush()

      expect loginRequired
        .toBe true
