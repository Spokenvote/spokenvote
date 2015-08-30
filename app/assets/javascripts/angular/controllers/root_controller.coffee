RootCtrl = ['$scope', '$rootScope', '$route', '$timeout', 'AlertService', '$location', '$modal', 'Auth', 'SessionService', 'SessionSettings', 'CurrentUserLoader', 'VotingService', ($scope, $rootScope, $route, $timeout, AlertService, $location, $modal, Auth, SessionService, SessionSettings, CurrentUserLoader, VotingService) ->
  $rootScope.alertService = AlertService
  $rootScope.authService = Auth
  $rootScope.sessionSettings = SessionSettings
  $rootScope.votingService = VotingService
  CurrentUserLoader().then (current_user) ->
    $rootScope.currentUser = current_user
    $location.path('/proposals').search('filter', 'my') if $rootScope.currentUser.username? and $location.path() == '/'

  window.fbAsyncInit = ->
    FB.init
      appId:
        switch $location.host().substring(0,3)
          when 'loc' then '449408378433518'
          when 'ser' then '449408378433518'
          when 'spo' then '720858044659536'
          when 'sta' then '122901591225638'
          when 'www' then '374325849312759'
      cookie: true
      status: true
      xfbml: true
      version: 'v2.1'

  ((d, s, id) ->
    js = undefined
    fjs = d.getElementsByTagName(s)[0]
    if d.getElementById(id)
      return
    js = d.createElement(s)
    js.id = id
    js.src = '//connect.facebook.net/en_US/sdk.js'
    fjs.parentNode.insertBefore js, fjs
    return
  ) document, 'script', 'facebook-jssdk'


  $scope.$on 'event:loginRequired', ->
    $scope.authService.signinFb($scope)

  $scope.$on 'cfpLoadingBar:completed', ->
    window.prerenderReady = true

  $timeout ( -> window.prerenderReady = true ), 10000

  $scope.signinAuth = ->
    modalInstance = $modal.open
      templateUrl: 'user/_auth_intro_modal.html'
      windowClass: 'dialog-sm'
    modalInstance.result.then (result) ->
      $scope.authService.signinFb($scope)

  $scope.userSettings = ->
    if SessionSettings.openModals.userSettings is false
      modalInstance = $modal.open
        templateUrl: 'user/_settings_modal.html'
        controller: 'UserSettingsCtrl'
      modalInstance.opened.then ->
        SessionSettings.openModals.userSettings = true
      modalInstance.result.finally ->
        SessionSettings.openModals.userSettings = false

  $scope.signOut = ->
    SessionService.userOmniauth.$destroy()
    $rootScope.currentUser = {}
    $location.path('/').search('')
    $scope.alertService.setInfo 'You are signed out of Spokenvote.', $scope, 'main'

  $scope.clearFilter = (filter) ->
    $location.search(filter, null)
    $rootScope.sessionSettings.routeParams.user = null

  $scope.showProposal = (proposal) ->
    $location.path('/proposals/' + proposal.id)        # Angular empty hash bug
#    $location.path('/proposals/' + proposal.id).hash('navigationBar')

  $scope.backtoTopics = ->
    $scope.sessionSettings.routeParams = $route.current.params
    $location.path('/proposals')    # Angular empty hash bug
#    $location.path('/proposals').hash('prop'+$scope.sessionSettings.routeParams.proposalId)

#  $scope.newTopic = ->
#    if $scope.currentUser.id?
#      $scope.votingService.new $scope
#    else
#      $scope.authService.signinFb($scope).then ->
#        $scope.votingService.new $scope

#  $scope.getStarted = ->
#    $scope.votingService.wizard $scope

  $rootScope.rootTips =
    newHub: "You may change the group to which you are directing
                              this proposal by clicking here."


  # All below has been decreciated in favor of Facebook sign in only

#    $scope.googleAuth2 = ->
#      gapi.auth.authorize SessionSettings.spokenvote_attributes.googleOauth2Config, ->
#        gapi.client.load "oauth2", "v2", ->
#          request = gapi.client.oauth2.userinfo.get(userId: "me")
#          request.execute (resp) ->
#            SessionService.userOmniauth.auth =
#              provider: 'google_oauth2'
#              uid: resp.id
#              name: resp.name
#              email: resp.email
#              avatar_url: resp.picture
#              token: gapi.auth.getToken()
#            signInRails()
#
#    $scope.signInModal = ->
#      if SessionSettings.openModals.signIn is false
#        opts =
#          resolve:
#            $scope: ->
#              $scope
#        d = $dialog.dialog(opts)
#        SessionSettings.openModals.signIn = true
#        d.open('user/_sign_in_modal.html', 'SessionCtrl').then (result) ->
#          SessionSettings.openModals.signIn = d.isOpen()
#
#    $scope.registerModal = ->       # $dialog.dialog no longer supported, must be updated to be used.
#      if SessionSettings.openModals.register is false
#        opts =
#          resolve:
#            $scope: ->
#              $scope
#        d = $dialog.dialog(opts)
#        SessionSettings.openModals.register = true
#        d.open('shared/_registration_modal.html', 'RegistrationCtrl').then (result) ->
#          SessionSettings.openModals.register = d.isOpen()
#
#    $scope.omniauthSession = SessionService.userOmniauth
#
#    $scope.userOmniauth = ( provider ) ->
#      $scope.omniauthSession.$save( provider ).success (response, status, headers, config) ->
#        if response.success == true
#          $scope.dismiss()
#          AlertService.setSuccess 'You  signed in using {{ provider }}!', $scope
#        #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
#        if response.success == false
#          AlertService.setCtlResult 'Sorry, we were not able to sign you in using {{ provider }}.', $scope

]

App.controller 'RootCtrl', RootCtrl