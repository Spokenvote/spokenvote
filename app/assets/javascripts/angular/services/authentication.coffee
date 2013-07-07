Authentication = ($q, $rootScope) ->

  resolve = (errval, retval, deferred) ->
    $rootScope.$apply ->
      if errval
        deferred.reject errval
      else
        retval.connected = true
        deferred.resolve retval

  getUser: (FB) ->
    deferred = $q.defer()
    FB.getLoginStatus (response) ->
      if response.status is "connected"
        FB.api "/me", (response) ->
          console.log response
          resolve null, response, deferred
      else if response.status is "not_authorized"
        FB.login (response) ->
          if response.authResponse
            FB.api "/me", (response) ->
              resolve null, response, deferred
          else
            resolve response.error, null, deferred

    promise = deferred.promise
    promise.connected = false
    promise

Authentication.$inject = [ '$q', '$rootScope' ]
App.Services.factory 'Authentication', Authentication
