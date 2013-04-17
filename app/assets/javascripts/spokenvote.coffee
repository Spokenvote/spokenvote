@angularApp = angular.module("Spokenvote", ["ngResource", '$strap.directives', 'ui'])

angularApp.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.post['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]

angularApp.controller "SpokenvoteCtrl", ($scope) ->
  $scope.model =
    message: "You have reached the Angular Route Provider :)"

  $scope.hubFilterSelect2 =
    minimumInputLength: 1
    placeholder: "Enter a group"
    width: 230
    allowClear: true
    ajax:
      url: "/hubs"
      dataType: "json"
      data: (term, page) ->
        hub_filter: term
#        location_id_filter: $(location_input).val()

      results: (data, page) ->
        results: data

      formatResult: (item) ->
        item.full_hub

      formatSelection: (item) ->
#        $(location_input).val item.formatted_location
#        $(location_id).val item.location_id #.closest('form').submit();
#        $(groupname_elem).val item.group_name
        item.group_name

      formatNoMatches: (term) ->
        'No matches. <a id="navCreateHub" onclick="angularApp.navCreateHub()" href="#">Create one</a>'

      initSelection: (element, callback) ->
        callback($scope.hub_filter_setting)


angularApp.navCreateHub = ($scope) ->
  angular.element("#s2id_hub_filter").select2 "close"
  angular.element("#hubModal").modal "show"
#  group_name = $(".select2-input").val()
#  $("#hubModal").find("#hub_group_name").val searchGroup
