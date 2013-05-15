RootCtrl = ($scope, AlertService, $location, $modal) ->
  $scope.alertService = AlertService

  $scope.$on "event:loginRequired", ->
    $scope.login()


  $scope.login = ->
    $modal
      template: '/assets/shared/_login_modal.html.haml'
      show: true
      backdrop: 'static'
      scope: $scope

  $scope.restoreCallingModal = ->
#    $scope.errorService.callingScope.show()        # feature for future use

RootCtrl.$inject = ['$scope', 'AlertService', '$location', '$modal']
angularApp.controller 'RootCtrl', RootCtrl
