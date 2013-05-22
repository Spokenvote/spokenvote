RootCtrl = ($scope, AlertService, $location, $modal, SessionService, CurrentUserLoader) ->
  $scope.alertService = AlertService
  CurrentUserLoader().then (current_user) ->
    $scope.currentUser = current_user

  $scope.$on "event:loginRequired", ->
    $scope.signIn()

  $scope.signIn = ->
    $modal
      template: '/assets/shared/_sign_in_modal.html.haml'
      show: true
      backdrop: 'static'
      scope: $scope

  $scope.register = ->
    $modal
      template: '/assets/shared/_registration_modal.html.haml'
      show: true
      backdrop: 'static'
      scope: $scope

  $scope.restoreCallingModal = ->
#    $scope.errorService.callingScope.show()        # feature for future use

  $scope.omniauthSession = SessionService.userOmniauth

  $scope.userOmniauth = ( provider ) ->
    $scope.omniauthSession.$save( provider ).success (response, status, headers, config) ->
    if response.success == true
      $scope.dismiss()
      AlertService.setSuccess 'You  signed in using {{ provider }}!'
    #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
    if response.success == false
      AlertService.setCtlResult 'Sorry, we were not able to sign you in using {{ provider }}.'

RootCtrl.$inject = ['$scope', 'AlertService', '$location', '$modal', 'SessionService', 'CurrentUserLoader']
angularApp.controller 'RootCtrl', RootCtrl
