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

AlertService = ->
  callingScope: null
  alertMessage: null
  jsonResponse: null
  jsonErrors: null
  alertClass: null
  cltActionResult: null

  setCallingScope: (scope) ->
    @callingScope = scope
    console.log @callingScope

  setSuccess: (msg) ->
    @alertMessage = msg
    @alertClass = 'alert-success'

  setError: (msg) ->
    @alertMessage = msg
    @alertClass = 'alert-error'

  setJson: (json) ->
    @jsonResponse = json
    @jsonErrors = json if json > ' '

  setCtlResult: (result) ->
    @cltActionResult = result
    @alertClass = 'alert-error'

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


HubSelected = ->
  group_name: "All Groups"
  id: "No id yet"

# Cookies
SpokenvoteCookies = ($cookies) ->
  $cookies.SpokenvoteSession = "Setting a value"
  sessionCookie: $cookies.SpokenvoteSession

# Register
App.Services.factory 'SessionService', SessionService
App.Services.factory 'AlertService', AlertService
App.Services.factory 'HubSelected', HubSelected
App.Services.factory 'SpokenvoteCookies', SpokenvoteCookies
App.Services.factory 'errorHttpInterceptor', errorHttpInterceptor