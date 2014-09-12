describe "Prerender Test", ->

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

  describe 'prerenderReady Test', ->

    it 'window.prerenderReady should be false', ->
      expect window.prerenderReady
        .toBe false

    it 'window.prerenderReady should be true after AJAX call is complete', ->

      $httpBackend.expectGET endpoint
        .respond 401

      $http.get endpoint
      $httpBackend.flush()

      expect window.prerenderReady
        .toBe true