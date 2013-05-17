SessionCtrl = ($scope, $cookieStore, Session, AlertService, $location, $modal) ->
  $scope.alertService = AlertService

  $scope.session = Session.userSession
  $scope.create = ->
    if Session.signedOut
      $scope.session.$save().success (data, status, headers, config) ->
        $cookieStore.put "_angular_devise_user", data   #_spokenvote_session

  $scope.destroy = ->
    $scope.session.$destroy()

#  $scope.$on "event:loginRequired", ->
#    $scope.login()
#
#
#  $scope.login = ->
#    $modal
#      template: '/assets/shared/_login_modal.html.haml'
#      show: true
#      backdrop: 'static'
#      scope: $scope

  $scope.restoreCallingModal = ->
#    $scope.errorService.callingScope.show()        # feature for future use

SessionCtrl.$inject = ['$scope', '$cookieStore', 'Session', 'AlertService', '$location', '$modal']
angularApp.controller 'SessionCtrl', SessionCtrl
