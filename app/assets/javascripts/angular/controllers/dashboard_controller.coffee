DashboardCtrl = ($scope, $route, $location, $dialog, SessionSettings, CurrentHubLoader, VotingService) ->
  console.log "SessionSettings.actions.changeHub: " + SessionSettings.actions.changeHub

  SessionSettings.routeParams = $route.current.params
  if $route.current.params.hub?
    $scope.hubFilter =
      full_hub: true

  $scope.$watch 'hubFilter.full_hub', ->
    if $scope.hubFilter?
      if $scope.hubFilter.full_hub == null
          $location.search('hub', null)
          SessionSettings.actions.hubFilter = "All Groups"
      else if SessionSettings.hub_attributes.id?
        $location.path('/proposals').search('hub', SessionSettings.hub_attributes.id)
        SessionSettings.actions.hubFilter = SessionSettings.hub_attributes.group_name

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

    formatResult: (searchedHub) ->
      searchedHub.full_hub

    formatSelection: (searchedHub) ->
      SessionSettings.hub_attributes = searchedHub
      SessionSettings.actions.changeHub = false
      searchedHub.full_hub

    formatNoMatches: (term) ->
      SessionSettings.actions.searchTerm = term
#      // The below sort of coded + injecting $compileProvider would be involved to move the "App." reference below inside of Angular; probably not worth trying to be that "pure"
#      $compile('No matches. If you are the first person to use this Group, please <button id="tempkim" ng-click="navCreateHub()" >create it</button>.')($scope)
      'No matches. If you are the first person to use this Group, please <a id="navCreateHub" onclick="App.navCreateHub()" href="javascript:" >create it</a>.'

    initSelection: (element, callback) ->
      CurrentHubLoader().then (searchedHub) ->
        SessionSettings.hub_attributes = searchedHub
        callback SessionSettings.hub_attributes


  App.navCreateHub = ->
    $scope.$apply ->
      VotingService.new $scope
      currentHub = SessionSettings.hub_attributes
      SessionSettings.hub_attributes = {}
      SessionSettings.hub_attributes.location_id = currentHub.location_id
      SessionSettings.hub_attributes.formatted_location = currentHub.formatted_location
      SessionSettings.actions.changeHub = 'new'
    angular.element('.select2-drop-active').select2 'close'
    angular.element('#newProposalHub').select2('data',null)

DashboardCtrl.$inject = [ '$scope', '$route', '$location', '$dialog', 'SessionSettings', 'CurrentHubLoader', 'VotingService' ]
App.controller 'DashboardCtrl', DashboardCtrl