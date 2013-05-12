RootCtrl = ($scope, ErrorService, $location, $modal) ->
  $scope.errorService = ErrorService
#  $scope.$watch $scope.errorService.errorMessage, ->
#    console.log "$scope.errorService: " + $scope.errorService.errorMessage

  $scope.$on "event:loginRequired", ->
#    $location.path "/login"
    console.log "You must be logged in"
    $scope.login()

  $scope.login = ->
    $modal
      template: '/assets/shared/_login_modal.html.haml'
      show: true
      backdrop: 'static'
      scope: $scope

RootCtrl.$inject = ['$scope', 'ErrorService', '$location', '$modal']
angularApp.controller 'RootCtrl', RootCtrl
