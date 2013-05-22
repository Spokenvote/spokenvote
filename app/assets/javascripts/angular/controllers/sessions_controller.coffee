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
          $cookieStore.put "spokenvote_email", $scope.session.email if $scope.session.remember_me == true
 #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
        if response.success == false
          AlertService.setCtlResult 'Sorry, we were not able to sign you in with the supplied email and password.'

  $scope.destroy = ->
    $scope.session.$destroy()

SessionCtrl.$inject = ['$scope', '$cookieStore', 'SessionService', 'AlertService']
angularApp.controller 'SessionCtrl', SessionCtrl

RegistrationCtrl = ($scope, $cookieStore, SessionService, AlertService) ->
  $scope.alertService = AlertService
  $scope.registration = SessionService.userRegistration

  $scope.register = ->
    AlertService.clearAlerts()
    if SessionService.signedOut
      $scope.registration.$save().success (response, status, headers, config) ->
        if response.success == true
          $scope.dismiss()
          AlertService.setSuccess 'Thank you for joining Spokenvote!'
 #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
        if response.success == false
          AlertService.setCtlResult 'Sorry, we were not able to save your registration.'

  $scope.destroy = ->
    $scope.registration.$destroy()

RegistrationCtrl.$inject = ['$scope', '$cookieStore', 'SessionService', 'AlertService']
angularApp.controller 'RegistrationCtrl', RegistrationCtrl


#angular.module("angularDevise.controllers").controller "RegistrationsController", [ "$scope", "$location", "Session", ($scope, $location, Session) ->
#  $scope.registration = Session.userRegistration
#  $scope.create = ->
#    $scope.registration.$save()
#
#  $scope.destroy = ->
#    $scope.registration.$destroy()
