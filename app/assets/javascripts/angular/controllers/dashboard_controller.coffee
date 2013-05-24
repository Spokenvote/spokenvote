DashboardCtrl = ($scope, $location, HubSelected, $modal) ->
  $scope.$location = $location
  hubSelected = HubSelected

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
    text: 'About this Site'
    click: "$location.path('/about')"
  ,
    text: 'Developers'
    href: 'http://railsforcharity.github.io/spokenvote/'
  ]

  $scope.user_dropdown = [
    text: 'My Proposals'
    click: "$location.path('/proposals').search('filter', 'my_votes')"
  ,
    text: 'Settings'
    click: 'console.log "click"'
  ,
    text: 'Sign Out'
    click: 'signOut()'
  ,
    text: 'Admin' # if $scope.currentUser.is_admin? == false
    click: "$location.path('/admin/dashboard')"
  ]

DashboardCtrl.$inject = ['$scope', '$location', 'HubSelected', '$modal']
angularApp.controller 'DashboardCtrl', DashboardCtrl