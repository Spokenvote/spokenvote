@angularApp = angular.module("Spokenvote", ["ngResource"])

angularApp.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.post['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]
angularApp.config ($routeProvider) ->
  $routeProvider
    .when('/'
      templateUrl: "/templates/app"
      controller: "SpokenvoteCtrl")
    .when('/hungry'
      template: "<h1>Getting tired of pizza. Switching to Fruit!</h1>")
    .otherwise(
      template: "<h1>Sorry, Angular does not have that route :(</h1"
    )

angularApp.controller "SpokenvoteCtrl", ($scope) ->
  $scope.model =
    message: "You have reached the Angular Route Provider :)"

angularApp.navCreateHub = ($scope, HubFilter) ->
  $("#s2id_hub_filter").select2 "close"
#  group_name = $(".select2-input").val()
#  $("#hubModal").find("#hub_group_name").val searchGroup
  $("#hubModal").modal()
