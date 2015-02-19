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
#  (promise) ->             # old, pre 1.3 logic
#    promise.then (response) ->
#      response
#    , (response) ->
#      if response.status is 406
#        AlertService.setError "Please sign in to continue."
#        $rootScope.$broadcast "event:loginRequired"
#      else AlertService.setError "The server was unable to process your request."  if response.status >= 400 and response.status < 500
#      $q.reject response

#  # optional method       # new, 1.3 logic
#  request: (config) ->
#    # do something on success
#    config

#  # optional method
#  requestError: (rejection) ->
#    # do something on error
#    return responseOrNewPromise  if canRecover(rejection)
#    $q.reject rejection

#  # optional method
#  response: (response) ->
#    # do something on success
#    response

  responseError: (rejection) ->
    # do something on error
      if rejection.status is 406
        AlertService.setError 'Please sign in to continue.'
        $rootScope.$broadcast 'event:loginRequired'
      else AlertService.setError 'The server was unable to process your request.'  if rejection.status >= 400 and rejection.status < 500
#      return responseOrNewPromise  if canRecover(rejection)
      $q.reject rejection


SessionSettings = ->
  facebookUser:
    auth: {}
    me: {}
  actions:
    changeHub: false
    detailPage: false
    focus: null
    hubFilter: 'All Groups'
    hubPlaceholder: 'Search for your Group ...'
    hubShow: true
    userFilter: null
    newProposal: {}
    newProposalHub: null
    offcanvas: false
    searchTerm: null
    selectHub: false
    wizardToGroup: null
  hub_attributes: {}
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
    getStarted: false
  proposal: null
  searchedHub: {}
  routeParams: {}
  newProposal: {}
  newSupport:
    target: null
    related: null
    save: null
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
      scope: [ 'https://www.googleapis.com/auth/plus.login', 'https://www.googleapis.com/auth/plus.me', 'https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/userinfo.profile' ]

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
