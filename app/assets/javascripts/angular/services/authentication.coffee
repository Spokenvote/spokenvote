Auth = ($q, $rootScope, SessionSettings, SessionService, AlertService, CurrentUserLoader) ->

  fbResolve = (userInfo, error, deferredFb, scope) ->
    $rootScope.$apply ->
      AlertService.clearAlerts()
      if userInfo
        SessionSettings.facebookUser.me = userInfo
        AlertService.setSuccess 'Facebook accepted your credentials. Now we\'re signing you into Spokenvote...', scope, 'main'
        signinSv deferredFb, scope
      else
        AlertService.setError 'Error trying to sign you in to Facebook. Please try again', scope, 'main'
        if error?
          AlertService.setCtlResult error.message, scope, 'main'
          console.log error.message   # permanent console.log
        deferredFb.reject error


  signinSv = (deferred, scope) ->
    SessionService.userOmniauth.auth =
      provider: 'facebook'
      uid: SessionSettings.facebookUser.me.id
      name: SessionSettings.facebookUser.me.name
      email: SessionSettings.facebookUser.me.email
      token: SessionSettings.facebookUser.auth.authResponse.accessToken
      expiresIn: SessionSettings.facebookUser.auth.authResponse.expiresIn

    if SessionService.signedOut
      SessionService.userOmniauth.$save().success (sessionResponse) ->
        if sessionResponse.success == true
          CurrentUserLoader().then (current_user) ->
            scope.currentUser = current_user
            AlertService.setInfo 'You are signed in to Spokenvote!', scope, 'main'
            deferred.resolve sessionResponse
        if sessionResponse.success == false
          AlertService.setCtlResult 'Sorry, we were not able to sign you in to Spokenvote.', $scope, 'main'
          deferred.reject sessionResponse


  signinFb: (scope) ->
    deferredFb = $q.defer()
    FB.getLoginStatus (authResponse) ->
      if authResponse.status is "connected"
        SessionSettings.facebookUser.auth = authResponse
        FB.api "/me", (userInfo) ->
          if userInfo.error
            fbResolve null, userInfo.error, deferredFb, scope
          else
            fbResolve userInfo, null, deferredFb, scope
      else
        FB.login (authResponse) ->
          SessionSettings.facebookUser.auth = authResponse
          if authResponse.status is "connected"
            FB.api "/me", (userInfo) ->
              if userInfo.error
                fbResolve null, userInfo.error, deferredFb, scope
              else
                fbResolve userInfo, null, deferredFb, scope
          else
            fbResolve null, authResponse, deferredFb, scope

    deferredFb.promise

Auth.$inject = [ '$q', '$rootScope', 'SessionSettings', 'SessionService', 'AlertService', 'CurrentUserLoader' ]
App.Services.factory 'Auth', Auth
