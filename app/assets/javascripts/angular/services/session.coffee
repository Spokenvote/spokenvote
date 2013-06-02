# Miscellaneous
SessionService = ($cookieStore, UserSessionResource, UserRegistrationResource, UserOmniauthResource) ->
  currentUser: $cookieStore.get '_spokenvote_session'

  signedIn: !!$cookieStore.get '_spokenvote_session'

  signedOut: not @signedIn

  userSession: new UserSessionResource
    email: $cookieStore.get 'spokenvote_email'
    password: null
    remember_me: true

  userOmniauth: new UserOmniauthResource
    provider: "facebook"

  userRegistration: new UserRegistrationResource
    name: null
    email: $cookieStore.get 'spokenvote_email'
    password: null
    password_confirmation: null

AlertService = ($timeout) ->
  callingScope: null
  alertMessage: null
  jsonResponse: null
  jsonErrors: null
  alertClass: null
  cltActionResult: null

  setSuccess: (msg, scope) ->
    @alertMessage = msg
    @alertClass = 'alert-success'
    $timeout  (-> scope.hideAlert()), 6000 if scope?

  setInfo: (msg, scope) ->
    @alertMessage = msg
    @alertClass = 'alert-info'
    $timeout  (-> scope.hideAlert()), 6000 if scope?

  setError: (msg, scope) ->
    @alertMessage = msg
    @alertClass = 'alert-error'
    $timeout  (-> scope.hideAlert()), 6000 if scope?

  setCtlResult: (result, scope) ->
    @cltActionResult = result
    @alertClass = 'alert-error'
    $timeout  (-> scope.hideAlert()), 6000 if scope?

  setJson: (json) ->
    @jsonResponse = json
    @jsonErrors = json if json > ' '

  setCallingScope: (scope) ->
    @callingScope = scope
    console.log @callingScope

  setClass: (alertclass) ->
    @alertClass = alertclass

  clearAlerts: ->
    @callingScope = null
    @alertMessage = null
    @jsonResponse = null
    @jsonErrors = null
    @alertClass = null
    @cltActionResult = null

# Interceptors
# Registers an interceptor for ALL angular ajax http calls
errorHttpInterceptor = ($q, $location, $rootScope, AlertService) ->
  (promise) ->
    promise.then ((response) ->
      response
    ), (response) ->
      if response.status is 406
        AlertService.setError "Please sign in to continue."
        $rootScope.$broadcast "event:loginRequired"
      else AlertService.setError "The server was unable to process your request."  if response.status >= 400 and response.status < 500
      $q.reject response


SessionSettings = ->
  selectedGroupID: 1
  selectedGroupName: "All Groups"
  selectedGroupLocation: "None"

#SessionSettings = -> [       #TODO trying to learn how to do it this way
#  selectedGroup: [
#    Name: "All Groups"
#  ]
#]


# Cookies
SpokenvoteCookies = ($cookies) ->
  $cookies.SpokenvoteSession = "Setting a value"
  sessionCookie: $cookies.SpokenvoteSession

# Injects
SessionService.$inject = [ '$cookieStore', 'UserSessionResource', 'UserRegistrationResource', 'UserOmniauthResource'  ]
AlertService.$inject = [ '$timeout' ]
errorHttpInterceptor.$inject = [ '$q', '$location', '$rootScope', 'AlertService' ]
SpokenvoteCookies.$inject = [ '$cookies' ]

# Register
App.Services.factory 'SessionService', SessionService
App.Services.factory 'AlertService', AlertService
App.Services.factory 'SessionSettings', SessionSettings
App.Services.factory 'SpokenvoteCookies', SpokenvoteCookies
App.Services.factory 'errorHttpInterceptor', errorHttpInterceptor