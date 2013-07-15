Auth = ($q, $rootScope, SessionSettings, AlertService) ->

  resolve = (userInfo, authError, deferred) ->
    $rootScope.$apply ->
      if userInfo
        userInfo.connected = true
        SessionSettings.facebookUser.me = userInfo
        deferred.resolve userInfo
      else
        AlertService.setError 'Error trying to sign you in to Facebook.', $scope, 'main'
        console.log 'Error signing in to Facebook.'
        deferred.reject authError

#  getUser: (FB) ->
#    AlertService.clearAlerts()
#    deferred = $q.defer()
#    FB.getLoginStatus (authResponse) ->
#      if authResponse.status != 'connected'
#        FB.login (authResponse) ->
#          SessionSettings.facebookUser.auth = authResponse
#          if authResponse.status is 'connected'
#            FB.api '/me', (userInfo) ->
#              SessionSettings.facebookUser.me = userInfo
#              railsSession(authResponse, userInfo)
#          else
#            AlertService.setError 'Error trying to sign you in to Facebook.', $scope, 'main'
#            console.log 'Error signing in to Facebook.'
#      else
#        FB.api '/me', (userInfo) ->
#          railsSession(authResponse, userInfo)
#          SessionSettings.facebookUser.me = userInfo
#      console.log SessionSettings.facebookUser.auth
#      console.log SessionSettings.facebookUser.me

  getFBUser: (FB) ->
    deferred = $q.defer()
    FB.getLoginStatus (authResponse) ->
      if authResponse.status is "connected"
        SessionSettings.facebookUser.auth = authResponse
        FB.api "/me", (userInfo) ->
          console.log userInfo
          resolve userInfo, null, deferred
      else if authResponse.status is "not_authorized"
        FB.login (authResponse) ->
          SessionSettings.facebookUser.auth = authResponse
          if authResponse.authResponse
            FB.api "/me", (userInfo) ->
              resolve userInfo, null, deferred
          else
            resolve null, authResponse.error, deferred

    promise = deferred.promise
    promise.connected = false
    promise




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

Auth.$inject = [ '$q', '$rootScope', 'SessionSettings', 'AlertService' ]
App.Services.factory 'Auth', Auth
