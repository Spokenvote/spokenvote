describe "Session Service Test", ->

#  $http = null
  $httpBackend = null
# $document = $timeout = result = loadingBar = null
  endpoint = '/service'

  beforeEach ->
    module 'spokenvote'

    inject (_$http_, _$httpBackend_, _$document_, _$timeout_) ->
  #    $http = _$http_
      $httpBackend = _$httpBackend_
  #    $document = _$document_
  #    $timeout = _$timeout_

  describe "Initial Validation Test", ->
    it "should match", ->
      expect("string").toMatch new RegExp("^string$")


  describe "Intercept Test", ->
    it 'should count http errors as responses so the loading bar can complete', inject (errorHttpInterceptor) ->
      # $httpBackend.expectGET(endpoint).respond response
      $httpBackend.expectGET endpoint
        .respond 401