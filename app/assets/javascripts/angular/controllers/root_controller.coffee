RootCtrl = ($scope, AlertService, $location, $modal, SessionService, SessionSettings, CurrentUserLoader) ->
  $scope.alertService = AlertService
  $scope.session = SessionService.userSession
  $scope.sessionSettings = SessionSettings
  CurrentUserLoader().then (current_user) ->
    $scope.currentUser = current_user
    $location.path('/proposals').search('filter', 'my_votes') if $scope.currentUser.username? and $location.path() == '/'

#    console.log $scope.currentUser
#    console.log $scope.currentUser.is_admin?
#  if $scope.currentUser.is_admin?.to_text is 'true'
#    console.log "console.log $scope.currentUser.is_admin?" + $scope.currentUser.is_admin?

  $scope.$on "event:loginRequired", ->
    $scope.signInModal()

  $scope.signInModal = ->
    $modal
      template: '/assets/shared/_sign_in_modal.html.haml'
      show: true
      backdrop: 'static'
      scope: $scope

  $scope.registerModal = ->
    $modal
      template: '/assets/shared/_registration_modal.html.haml'
      show: true
      backdrop: 'static'
      scope: $scope

  $scope.signOut = ->
    $scope.session.$destroy()
    $scope.currentUser = {}
    $location.path('/').search('')
    AlertService.setInfo 'You are signed out.', $scope

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

RootCtrl.$inject = ['$scope', 'AlertService', '$location', '$modal', 'SessionService', 'SessionSettings', 'CurrentUserLoader' ]
App.controller 'RootCtrl', RootCtrl