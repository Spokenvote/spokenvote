DashboardCtrl = ($scope, $location, $modal, SessionSettings) ->

  $scope.$watch 'hubFilter', ->
    if $scope.hubFilter == null
      $location.search('hub', null)
      SessionSettings.hub_attributes.group_name = "All Groups"
    else if $scope.hubFilter?
      $location.path('/proposals').search('hub', SessionSettings.hub_attributes.hub_id)

  $scope.hubFilterSelect2 =
    minimumInputLength: 1
    placeholder: " Begin typing to find your Group or Location ..."
    width: '500px'
    allowClear: true
    ajax:
      url: "/hubs"
      dataType: "json"
      data: (term, page) ->
        hub_filter: term

      results: (data, page) ->
        results: data

    formatResult: (item) ->
      item.full_hub

    formatSelection: (item) ->
      SessionSettings.hub_attributes.hub_id = item.id
      SessionSettings.hub_attributes.group_name = item.group_name
      SessionSettings.hub_attributes.formatted_location = item.formatted_location
      SessionSettings.hub_attributes.full_hub = item.full_hub
      SessionSettings.hub_attributes.changeHub = null
      item.full_hub


    formatNoMatches: (term) ->
      $scope.searchGroupTerm = term
      console.log $scope.searchGroupTerm
      'No matches. If you are the first person to use this Group, please <a id="navCreateHub" onclick="App.navCreateHub()" href="#">create it</a>.'

    initSelection: (element, callback) ->
      callback()

  App.navCreateHub = ->
    angular.element("#s2id_hub_filter").select2 "close"
    $modal
      template: '/assets/hubs/_new_hub_modal.html.haml'
      show: true
      backdrop: 'static'
      scope: $scope

DashboardCtrl.$inject = ['$scope', '$location', '$modal', 'SessionSettings']
App.controller 'DashboardCtrl', DashboardCtrl