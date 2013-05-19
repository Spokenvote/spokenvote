SessionCtrl = ($scope, $cookieStore, SessionService, AlertService) ->
  $scope.alertService = AlertService
  $scope.session = SessionService.userSession

  $scope.create = ->
    AlertService.clearAlerts()
    if SessionService.signedOut
      $scope.session.$save().success (response, status, headers, config) ->
        if response.success == true
          $scope.dismiss()
          AlertService.setSuccess 'You are signed in!'
 #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
        if response.success == false
          AlertService.setCtlResult 'Sorry, we were not able to sign you in with the supplied email and password.'

  $scope.destroy = ->
    $scope.session.$destroy()

SessionCtrl.$inject = ['$scope', '$cookieStore', 'SessionService', 'AlertService']
angularApp.controller 'SessionCtrl', SessionCtrl
