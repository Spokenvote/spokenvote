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
    auth: null

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
  alertDestination: null
  cltActionResult: null

  setSuccess: (msg, scope, dest) ->
    @alertMessage = msg
    @alertDestination = dest
    @alertClass = 'alert-success'
    $timeout  (-> scope.hideAlert()), 7000 if scope?

  setInfo: (msg, scope, dest) ->
    @alertMessage = msg
    @alertDestination = dest
    @alertClass = 'alert-info'
    $timeout  (-> scope.hideAlert()), 7000 if scope?

  setError: (msg, scope, dest) ->
    @alertMessage = msg
    @alertDestination = dest
    @alertClass = 'alert-danger'
    $timeout  (-> scope.hideAlert()), 7000 if scope?

  setCtlResult: (result, scope, dest) ->
    @cltActionResult = result
    @alertDestination = dest
    @alertClass = 'alert-danger'
#    $timeout  (-> scope.hideAlert()), 7000 if scope?

  setJson: (json) ->
    @jsonResponse = json
    @jsonErrors = json if json > ' '

  setCallingScope: (scope) ->
    @callingScope = scope

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
  facebookUser:
    auth: {}
    me: {}
  actions:
    hubFilter: 'All Groups'
    userFilter: null
    changeHub: false
    newProposalHub: null
    searchTerm: null
    selectHub: false
  openModals:
    signIn: false
    register: false
    register: false
    userSettings: false
    supportProposal: false
    improveProposal: false
    newProposal: false
    editProposal: false
    deleteProposal: false
  searchedHub: {}
  routeParams: {}
  hub_attributes: {}
  lastLocation:
    location_id: null
    formatted_location: null
  socialSharing:
    twitterRootUrl: 'http://twitter.com/home?status='
    facebookRootUrl: 'http://www.facebook.com/sharer.php?u='
    googleRootUrl: 'https://plus.google.com/share?url='
  spokenvote_attributes:
    defaultGravatar: 'http://www.spokenvote.com/' + 'assets/icons/sv-30.png'
    googleOauth2Config:
      client_id: '390524033908-kqnb56kof2vfr4gssi2q84nth2n981g5'
      scope: [ 'https://www.googleapis.com/auth/plus.login',
               'https://www.googleapis.com/auth/plus.me',
               'https://www.googleapis.com/auth/userinfo.email',
               'https://www.googleapis.com/auth/userinfo.profile' ]

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
App.Services.factory 'errorHttpInterceptor', errorHttpInterceptor
App.Services.factory 'SpokenvoteCookies', SpokenvoteCookies
App.Services.factory 'SessionSettings', SessionSettings
