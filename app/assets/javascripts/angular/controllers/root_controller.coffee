RootCtrl = ($scope, AlertService, $location, $dialog, SessionService, SessionSettings, CurrentUserLoader) ->
  $scope.alertService = AlertService
#  $scope.session = SessionService.userSession
#  $scope.session = SessionService.userOmniauth
  $scope.sessionSettings = SessionSettings
  CurrentUserLoader().then (current_user) ->
    $scope.currentUser = current_user
    $location.path('/proposals').search('filter', 'my_votes') if $scope.currentUser.username? and $location.path() == '/'

  $scope.$on "event:loginRequired", ->
    $scope.signInModal()

  $scope.authenticate = ->
    gapi.auth.authorize SessionSettings.spokenvote_attributes.googleOauth2Config, ->
      console.log "login complete"
      console.log gapi.auth.getToken()
      $scope.authToken = gapi.auth.getToken()
      gapi.client.load "oauth2", "v2", ->
        request = gapi.client.oauth2.userinfo.get(userId: "me")
        request.execute (resp) ->
          console.log resp
          SessionService.userOmniauth.auth =
            provider: 'google_oauth2'
            uid: resp.id
            name: resp.name
            email: resp.email
            avatar_url: resp.picture
            token: $scope.authToken.access_token
#          SessionService.userOmniauth.auth = auth
          console.log SessionService.userOmniauth.auth
          AlertService.clearAlerts()
          if SessionService.signedOut
            SessionService.userOmniauth.$save().success (response, status, headers, config) ->
              console.log response
              if response.success == true
                $scope.updateUserSession()
                $location.path('/proposals').search('filter', 'my_votes')
                AlertService.setInfo 'You are signed in!', $scope, 'main'
                $cookieStore.put "spokenvote_email", $scope.session.email if $scope.session.remember_me == true
              #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
              if response.success == false
                AlertService.setCtlResult 'Sorry, we were not able to sign you in with the supplied email and password.', $scope, 'main'


  $scope.makeApiCall = ->
    gapi.client.load "oauth2", "v2", ->
  #      request = gapi.client.plus.people.get(userId: "me")
      request = gapi.client.oauth2.userinfo.get(userId: "me")
      request.execute (resp) ->
        auth =
          provider: 'google_oauth2'
          uid: resp.id
          name: resp.name
          email: resp.email
          avatar_url: resp.picture
          token: $scope.authToken.access_token
        SessionService.userOmniauth.auth = auth

        console.log SessionService.userOmniauth.auth
        console.log gapi.auth.getToken()


  $scope.devise = ->
#    SessionService.userOmniauth =
#      provider: 'google_oauth2'
#      uid: $scope.user.id
#      name: $scope.user.name
#      email: $scope.user.email
#      avatar_url: $scope.user.picture
#      token: $scope.authToken.access_token

    console.log SessionService.userOmniauth
#    console.log SessionService.userSession


#    #    AlertService.clearAlerts()
#    console.log user

    SessionService.userOmniauth.$save().success (response, status, headers, config) ->
      console.log response
#    ,  (response, status, headers, config) ->
#      console.log response
#      #      $location.path('/proposals/' + response.id)
#      #      AlertService.setSuccess 'Your improved proposal stating: \"' + response.statement + '\" was created.', $scope, 'main'
#      dialog.close(response)
#    ,  (response, status, headers, config) ->
#  #      AlertService.setCtlResult 'Sorry, your improved proposal was not saved.', $scope, 'modal'
#  #      AlertService.setJson response.data





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

  $scope.signOut = ->
    SessionService.userOmniauth.$destroy()
#    $scope.session.$destroy()
    $scope.currentUser = {}
    $location.path('/').search('')
    AlertService.setInfo 'You are signed out.', $scope, 'main'

  $scope.updateUserSession = ->
    CurrentUserLoader().then (current_user) ->
      $scope.currentUser = current_user

  $scope.restoreCallingModal = ->
#    $scope.errorService.callingScope.show()        # feature for future use

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