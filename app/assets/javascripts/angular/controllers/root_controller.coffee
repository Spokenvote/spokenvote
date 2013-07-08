RootCtrl = ($scope, AlertService, $location, $dialog, SessionService, SessionSettings, CurrentUserLoader) ->
  $scope.alertService = AlertService
  $scope.sessionSettings = SessionSettings
  CurrentUserLoader().then (current_user) ->
    $scope.currentUser = current_user
    $location.path('/proposals').search('filter', 'my_votes') if $scope.currentUser.username? and $location.path() == '/'

  $scope.$on "event:loginRequired", ->
    $scope.facebookAuth2()

  $scope.facebookAuth2 = ->
    AlertService.clearAlerts()

    FB.getLoginStatus (authResponse) ->
      if authResponse.status != 'connected'
        FB.login (authResponse) ->
          if authResponse.status is 'connected'
              FB.api '/me', (userInfo) ->
                railsSession(authResponse, userInfo)
          else
            AlertService.setError 'Error trying to sign you in to Facebook.', $scope, 'main'
            console.log 'Error signing in to Facebook.'
      else
          FB.api '/me', (userInfo) ->
            railsSession(authResponse, userInfo)

  railsSession = (authResponse, userInfo)->
    SessionService.userOmniauth.auth =
      provider: 'facebook'
      uid: userInfo.id
      name: userInfo.name
      email: userInfo.email
      avatar_url: null
      token: authResponse.authResponse.accessToken
      expiresIn: authResponse.authResponse.expiresIn
    signInRails()

  signInRails = ->
    AlertService.clearAlerts()
    if SessionService.signedOut
      SessionService.userOmniauth.$save().success (response) ->
        if response.success == true
          $scope.updateUserSession()
          AlertService.setInfo 'You are signed in!', $scope, 'main'
#          $cookieStore.put "spokenvote_email", SessionService.userOmniauth.auth.email
        if response.success == false
          AlertService.setCtlResult 'Sorry, we were not able to sign you in with the supplied email and password.', $scope, 'main'

  $scope.updateUserSession = ->
    CurrentUserLoader().then (current_user) ->
      $scope.currentUser = current_user

  $scope.signOut = ->
    SessionService.userOmniauth.$destroy()
    #    $scope.session.$destroy()
    $scope.currentUser = {}
    $location.path('/').search('')
    AlertService.setInfo 'You are signed out.', $scope, 'main'


  $scope.restoreCallingModal = ->
#    $scope.errorService.callingScope.show()        # feature for future use

# Decreciated in favor of Facebook sign in only
  $scope.googleAuth2 = ->
    gapi.auth.authorize SessionSettings.spokenvote_attributes.googleOauth2Config, ->
      gapi.client.load "oauth2", "v2", ->
        request = gapi.client.oauth2.userinfo.get(userId: "me")
        request.execute (resp) ->
          SessionService.userOmniauth.auth =
            provider: 'google_oauth2'
            uid: resp.id
            name: resp.name
            email: resp.email
            avatar_url: resp.picture
            token: gapi.auth.getToken()
          signInRails()

  $scope.signInModal = ->
    if SessionSettings.openModals.signIn is false
      opts =
        resolve:
          $scope: ->
            $scope
      d = $dialog.dialog(opts)
      SessionSettings.openModals.signIn = true
      d.open('/assets/shared/_sign_in_modal.html.haml', 'SessionCtrl').then (result) ->
        SessionSettings.openModals.signIn = d.isOpen()

  $scope.registerModal = ->
    if SessionSettings.openModals.register is false
      opts =
        resolve:
          $scope: ->
            $scope
      d = $dialog.dialog(opts)
      SessionSettings.openModals.register = true
      d.open('/assets/shared/_registration_modal.html.haml', 'RegistrationCtrl').then (result) ->
        SessionSettings.openModals.register = d.isOpen()

  $scope.omniauthSession = SessionService.userOmniauth

  $scope.userOmniauth = ( provider ) ->
    $scope.omniauthSession.$save( provider ).success (response, status, headers, config) ->
      if response.success == true
        $scope.dismiss()
        AlertService.setSuccess 'You  signed in using {{ provider }}!', $scope
      #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
      if response.success == false
        AlertService.setCtlResult 'Sorry, we were not able to sign you in using {{ provider }}.', $scope

RootCtrl.$inject = ['$scope', 'AlertService', '$location', '$dialog', 'SessionService', 'SessionSettings', 'CurrentUserLoader' ]
App.controller 'RootCtrl', RootCtrl