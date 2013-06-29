SessionCtrl = ($scope, $cookieStore, $location, SessionService, AlertService, dialog) ->
  $scope.alertService = AlertService
  $scope.session = SessionService.userSession

  $scope.signIn = ->
    AlertService.clearAlerts()
    if SessionService.signedOut
      $scope.session.$save().success (response, status, headers, config) ->
        if response.success == true
          dialog.close(response)
          $scope.updateUserSession()
          $location.path('/proposals').search('filter', 'my_votes')
          AlertService.setInfo 'You are signed in!', $scope, 'main'
          $cookieStore.put "spokenvote_email", $scope.session.email if $scope.session.remember_me == true
        #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
        if response.success == false
          AlertService.setCtlResult 'Sorry, we were not able to sign you in with the supplied email and password.', $scope, 'modal'

  $scope.close = (result) ->
    dialog.close(result)

RegistrationCtrl = ($scope, $cookieStore, $location, SessionService, AlertService, dialog) ->
  $scope.alertService = AlertService
  $scope.registration = SessionService.userRegistration

  $scope.register = ->
    AlertService.clearAlerts()
    if SessionService.signedOut
      $scope.registration.$save().success (response, status, headers, config) ->
        if response.success == true
          dialog.close(response)
          $location.path('/proposals').search('filter', 'active')
          AlertService.setInfo 'Thank you for joining Spokenvote!', $scope, 'main'
          $scope.updateUserSession()
 #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
        if response.success == false
          AlertService.setCtlResult 'Sorry, we were not able to save your registration.', $scope, 'modal'

  $scope.destroy = ->
    $scope.registration.$destroy()

  $scope.close = (result) ->
    dialog.close(result)

# Injects
SessionCtrl.$inject = [ '$scope', '$cookieStore', '$location', 'SessionService', 'AlertService', 'dialog' ]
RegistrationCtrl.$inject = [ '$scope', '$cookieStore', '$location', 'SessionService', 'AlertService', 'dialog' ]

# Register
App.controller 'SessionCtrl', SessionCtrl
App.controller 'RegistrationCtrl', RegistrationCtrl