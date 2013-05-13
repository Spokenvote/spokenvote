RootCtrl = ($scope, ErrorService, $location, $modal) ->
  $scope.errorService = ErrorService

#  $scope.jsonResponse = {}
#  $scope.$watch $scope.jsonResponse, ->
#    $scope.jsonErrors = $scope.jsonResponse
#    console.log  $scope.jsonErrors

  $scope.$watch $scope.errorService, ->
    console.log "$scope.errorService: " + $scope.errorService.errorMessage
    console.log "$scope.errorService.jsonResponse: " + $scope.errorService.jsonResponse

  $scope.$on "event:loginRequired", ->
#    $location.path "/login"
    console.log  "From $scope.$on event:loginRequired: " + $scope.errorService.errorMessage
    console.log "$scope.errorService.jsonResponse: " + $scope.errorService.jsonResponse

  #    $scope.login()

  $scope.login = ->
    $modal
      template: '/assets/shared/_login_modal.html.haml'
      show: true
      backdrop: 'static'
      scope: $scope

RootCtrl.$inject = ['$scope', 'ErrorService', '$location', '$modal']
angularApp.controller 'RootCtrl', RootCtrl
