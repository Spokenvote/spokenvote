DashboardCtrl = ($scope, $location, HubSelected, $modal) ->
  hubSelected = HubSelected
  $scope.model =
    message: "You have reached the Angular Route Provider :)"

  $scope.hubFilterSelect2 =
    minimumInputLength: 1
    placeholder: " Begin typing to find your Group or Location ..."
    width: '450px'
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
      hubSelected.id = item.id
      hubSelected.group_name = item.group_name
      $location.search('hub', item.id)
      item.full_hub

    formatNoMatches: (term) ->
      $scope.searchGroupTerm = term
      'No matches. If you are the first person to use this Group, please <a id="navCreateHub" onclick="angularApp.navCreateHub()" href="#">create it</a>.'

    initSelection: (element, callback) ->
      callback($scope.hubFilter.group_name)


  angularApp.navCreateHub = ->
    angular.element("#s2id_hub_filter").select2 "close"
    $modal
      template: '/assets/hubs/_new_hub_modal.html.haml'
      show: true
      backdrop: 'static'
      scope: $scope


  $scope.help_dropdown = [
#    text: 'About this Site'
#    click: '$location.path("http://railsforcharity.github.io/spokenvote/")'
#  ,
    text: 'Developers'
    click: "$location.path('http://railsforcharity.github.io/spokenvote/')"
  ]

DashboardCtrl.$inject = ['$scope', '$location', 'HubSelected', '$modal']
angularApp.controller 'DashboardCtrl', DashboardCtrl