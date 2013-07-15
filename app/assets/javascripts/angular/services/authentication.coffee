Auth = ($q, $rootScope, SessionSettings, SessionService, AlertService) ->

  fbResolve = (userInfo, error, deferredFb, scope) ->
    $rootScope.$apply ->
      AlertService.clearAlerts()
      if userInfo
        console.log userInfo
#        userInfo.connected = true
        SessionSettings.facebookUser.me = userInfo
        AlertService.setSuccess 'Facebook accepted your credentials. Now we\'re signing you into Spokenvote...', scope, 'main'
        signinSv deferredFb, scope
#        signinSv(scope).then (sessionResponse) ->
#          console.log sessionResponse
#          deferredFb.resolve sessionResponse
      else
        AlertService.setError 'Error trying to sign you in to Facebook. Please try again', scope, 'main'
        if error?
          AlertService.setCtlResult error.message, scope, 'main'
          console.log error.message
        deferredFb.reject error


  signinSv = (deferred, scope) ->
#    deferredSv = $q.defer()
    SessionService.userOmniauth.auth =
      provider: 'facebook'
      uid: SessionSettings.facebookUser.me.id
      name: SessionSettings.facebookUser.me.name
      email: SessionSettings.facebookUser.me.email
#      avatar_url: null
      token: SessionSettings.facebookUser.auth.authResponse.accessToken
      expiresIn: SessionSettings.facebookUser.auth.authResponse.expiresIn

    AlertService.clearAlerts()
    if SessionService.signedOut
      SessionService.userOmniauth.$save().success (sessionResponse) ->
        if sessionResponse.success == true
          scope.updateUserSession()
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
          console.log userInfo
          if userInfo.error
            fbResolve null, userInfo.error, deferredFb, scope
          else
            fbResolve userInfo, null, deferredFb, scope
      else
        FB.login (authResponse) ->
          SessionSettings.facebookUser.auth = authResponse
          if authResponse.authResponse
            FB.api "/me", (userInfo) ->
              console.log userInfo
              if userInfo.error
                fbResolve null, userInfo.error, deferredFb, scope
              else
                fbResolve userInfo, null, deferredFb, scope
          else
            fbResolve null, authResponse.error, deferredFb, scope

#    promise.connected = false
    deferredFb.promise
#    promise


#    deferredSv.promise

#  resolve = (errval, retval, deferred) ->
#    $rootScope.$apply ->
#      if errval
#        deferred.reject errval
#      else
#        retval.connected = true
#        deferred.resolve retval
#
#  getUser: (FB) ->
#    deferred = $q.defer()
#    FB.getLoginStatus (response) ->
#      if response.status is "connected"
#        FB.api "/me", (response) ->
#          console.log response
#          resolve null, response, deferred
#      else if response.status is "not_authorized"
#        FB.login (response) ->
#          if response.authResponse
#            FB.api "/me", (response) ->
#              resolve null, response, deferred
#          else
#            resolve response.error, null, deferred
#
#    promise = deferred.promise
#    promise.connected = false
#    promise

Auth.$inject = [ '$q', '$rootScope', 'SessionSettings', 'SessionService', 'AlertService' ]
App.Services.factory 'Auth', Auth
