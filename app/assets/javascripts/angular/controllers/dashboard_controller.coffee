DashboardCtrl = ($scope, $location, $modal, SessionSettings) ->

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
      SessionSettings.selectedGroupName = item.group_name
      $location.path('/proposals').search('hub', item.id)
      $scope.$watch 'hubFilter', ->
        if $scope.hubFilter == null
          $location.search('hub', null)
          SessionSettings.selectedGroupName = "All Groups"
      item.full_hub

    formatNoMatches: (term) ->
      $scope.searchGroupTerm = term
      'No matches. If you are the first person to use this Group, please <a id="navCreateHub" onclick="App.navCreateHub()" href="#">create it</a>.'

    initSelection: (element, callback) ->
      callback($scope.hubFilter.group_name)

  App.navCreateHub = ->
    angular.element("#s2id_hub_filter").select2 "close"
    $modal
      template: '/assets/hubs/_new_hub_modal.html.haml'
      show: true
      backdrop: 'static'
      scope: $scope

DashboardCtrl.$inject = ['$scope', '$location', '$modal', 'SessionSettings']
App.controller 'DashboardCtrl', DashboardCtrl