@angularApp = angular.module("Spokenvote", ["ngResource", '$strap.directives'])

angularApp.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.post['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]

angularApp.controller "SpokenvoteCtrl", ($scope) ->
  $scope.model =
    message: "You have reached the Angular Route Provider :)"

angularApp.navCreateHub = ($scope) ->
  angular.element("#s2id_hub_filter").select2 "close"
  angular.element("#hubModal").modal "show"
#  group_name = $(".select2-input").val()
#  $("#hubModal").find("#hub_group_name").val searchGroup
