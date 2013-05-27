SessionCtrl = ($scope, $cookieStore, $location, SessionService, AlertService) ->
  $scope.alertService = AlertService
  $scope.session = SessionService.userSession

  $scope.signIn = ->
    AlertService.clearAlerts()
    if SessionService.signedOut
      $scope.session.$save().success (response, status, headers, config) ->
        if response.success == true
          $scope.dismiss()
          $scope.updateUserSession()
          $location.path('/proposals').search('filter', 'my_votes')
          AlertService.setSuccess 'You are signed in!'
          $cookieStore.put "spokenvote_email", $scope.session.email if $scope.session.remember_me == true
        #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
        if response.success == false
          AlertService.setCtlResult 'Sorry, we were not able to sign you in with the supplied email and password.'

RegistrationCtrl = ($scope, $cookieStore, $location, SessionService, AlertService) ->
  $scope.alertService = AlertService
  $scope.registration = SessionService.userRegistration

  $scope.register = ->
    AlertService.clearAlerts()
    if SessionService.signedOut
      $scope.registration.$save().success (response, status, headers, config) ->
        if response.success == true
          $scope.dismiss()
          $location.path('/proposals').search('filter', 'active')
          AlertService.setSuccess 'Thank you for joining Spokenvote!'
          $scope.updateUserSession()
 #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
        if response.success == false
          AlertService.setCtlResult 'Sorry, we were not able to save your registration.'

  $scope.destroy = ->
    $scope.registration.$destroy()

# Register
App.controller 'SessionCtrl', SessionCtrl
App.controller 'RegistrationCtrl', RegistrationCtrl