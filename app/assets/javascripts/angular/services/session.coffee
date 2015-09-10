# Miscellaneous
SessionService = ($cookieStore, UserOmniauthResource) ->
  currentUser: $cookieStore.get '_spokenvote_session'

  signedIn: !!$cookieStore.get '_spokenvote_session'

  signedOut: not @signedIn

  userOmniauth: new UserOmniauthResource
    auth: null

#  loadHub: ($rootScope, CurrentHubLoader) ->
#    CurrentHubLoader().then (paramHub) ->
#      $rootScope.sessionSettings.hub_attributes = paramHub
#      $rootScope.sessionSettings.hub_attributes.id = $scope.sessionSettings.hub_attributes.select_id     # Supports cold start on existing GL location
#      $rootScope.sessionSettings.actions.hubShow = true

#  userSession: new UserSessionResource            # TODO Planned future use
#    email: $cookieStore.get 'spokenvote_email'
#    password: null
#    remember_me: true

#  userRegistration: new UserRegistrationResource
#    name: null
#    email: $cookieStore.get 'spokenvote_email'
#    password: null
#    password_confirmation: null

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

  responseError: (rejection) ->
    # do something on error
      if rejection.status is 406
        AlertService.setError 'Please sign in to continue.'
        $rootScope.$broadcast 'event:loginRequired'
      else AlertService.setError 'The server was unable to process your request.'  if rejection.status >= 400 and rejection.status < 500
      $q.reject rejection


SessionSettings = ->
  facebookUser:
    auth: {}
    me: {}
  actions:
    detailPage: false
    focus: null
    hub_attributes: null
    hubSeekOnSearch: true
    hubPlaceholder: 'Search to find your Group ...'
    hubShow: true
    newVoteDetails: {}
    offcanvas: false
    userFilter: null
#    improveProposal:
#      propStepText: ''
#      commentStepText: ''
#    newProposal: {}
#    newProposalHub: null
#    selectHub: false
#    wizardToGroup: null
  openModals:
#    signIn: false
#    register: false
#    userSettings: false
#    supportProposal: false
#    improveProposal: false
#    newProposal: false
#    editProposal: false
    deleteProposal: false
#    getStarted: false
#  proposal: null
#  vote: {}
#  searchedHub: {}
#  newSupport:
#    related: null
#    target: null
#    vote: null
  lastLocation:
    location_id: null
    formatted_location: null
  newVote: {}
  routeParams: {}
  socialSharing:
    twitterRootUrl: 'http://twitter.com/home?status='
    facebookRootUrl: 'http://www.facebook.com/sharer.php?u='
    googleRootUrl: 'https://plus.google.com/share?url='
  spokenvote_attributes:
    minimumHubNameLength: 3
    minimumProposalLength: 5
    minimumCommentLength: 5
    defaultGravatar: 'http://www.spokenvote.org/' + 'assets/icons/sv-30.png'
    googleOauth2Config:
      client_id: '390524033908-kqnb56kof2vfr4gssi2q84nth2n981g5'
      scope: [ 'https://www.googleapis.com/auth/plus.login', 'https://www.googleapis.com/auth/plus.me', 'https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/userinfo.profile' ]

# Cookies
SpokenvoteCookies = ($cookies) ->
  $cookies.SpokenvoteSession = "Setting a value"
  sessionCookie: $cookies.SpokenvoteSession

# Injects
SessionService.$inject = [ '$cookieStore', 'UserOmniauthResource'  ]
#SessionService.$inject = [ '$cookieStore', 'UserSessionResource', 'UserRegistrationResource', 'UserOmniauthResource'  ]
AlertService.$inject = [ '$timeout' ]
errorHttpInterceptor.$inject = [ '$q', '$location', '$rootScope', 'AlertService' ]
SpokenvoteCookies.$inject = [ '$cookies' ]

# Register
App.Services.factory 'SessionService', SessionService
App.Services.factory 'AlertService', AlertService
App.Services.factory 'errorHttpInterceptor', errorHttpInterceptor
App.Services.factory 'SpokenvoteCookies', SpokenvoteCookies
App.Services.factory 'SessionSettings', SessionSettings
