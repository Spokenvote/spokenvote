RootCtrl = ($scope, $rootScope, AlertService, $location, $dialog, Auth, SessionService, SessionSettings, CurrentUserLoader) ->
  $rootScope.alertService = AlertService
  $rootScope.authService = Auth
  $rootScope.sessionSettings = SessionSettings
  CurrentUserLoader().then (current_user) ->
    $rootScope.currentUser = current_user
    $location.path('/proposals').search('filter', 'my') if $rootScope.currentUser.username? and $location.path() == '/'

  $scope.$on "event:loginRequired", ->
    $scope.authService.signinFb($scope)

  $scope.signinAuth = ->
    $scope.authService.signinFb($scope)

  $scope.userSettings = ->
    if SessionSettings.openModals.userSettings is false
      opts =
        resolve:
          $scope: ->
            $scope
      d = $dialog.dialog(opts)
      SessionSettings.openModals.userSettings = true
      d.open('/assets/user/_support_modal.html.haml', 'UserSettingsCtrl').then (result) ->
        SessionSettings.openModals.userSettings = d.isOpen()

  $scope.signOut = ->
    SessionService.userOmniauth.$destroy()
    $rootScope.currentUser = {}
    $location.path('/').search('')
    AlertService.setInfo 'You are signed out of Spokenvote.', $scope, 'main'

  $scope.clearFilter = (filter) ->
    $location.search(filter, null)
    $rootScope.sessionSettings.actions.userFilter = null


  # All below had been decreciated in favor of Facebook sign in only
  $scope.googleAuth2 = ->
    gapi.auth.authorize SessionSettings.spokenvote_attributes.googleOauth2Config, ->
      gapi.client.load "oauth2", "v2", ->
        request = gapi.client.oauth2.userinfo.get(userId: "me")
        request.execute (resp) ->
          SessionService.userOmniauth.auth =
            provider: 'google_oauth2'
            uid: resp.id
            name: resp.name
            email: resp.email
            avatar_url: resp.picture
            token: gapi.auth.getToken()
          signInRails()

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

  $scope.omniauthSession = SessionService.userOmniauth

  $scope.userOmniauth = ( provider ) ->
    $scope.omniauthSession.$save( provider ).success (response, status, headers, config) ->
      if response.success == true
        $scope.dismiss()
        AlertService.setSuccess 'You  signed in using {{ provider }}!', $scope
      #        $cookieStore.put "_spokenvote_session", response   #let Angular set the cookie in the future?
      if response.success == false
        AlertService.setCtlResult 'Sorry, we were not able to sign you in using {{ provider }}.', $scope

RootCtrl.$inject = ['$scope', '$rootScope', 'AlertService', '$location', '$dialog', 'Auth', 'SessionService', 'SessionSettings', 'CurrentUserLoader' ]
App.controller 'RootCtrl', RootCtrl