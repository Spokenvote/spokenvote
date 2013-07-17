DashboardCtrl = ($scope, $route, $location, SessionSettings, CurrentHubLoader, VotingService) ->
  $scope.hubFilter =
    hubFilter: null

  SessionSettings.routeParams = $route.current.params

  if $route.current.params.hub?
    $scope.hubFilter =
      hubFilter: true

  $scope.$on '$locationChangeSuccess', ->
    if $route.current.params.hub? and $scope.hubFilter.hubFilter is null
      CurrentHubLoader().then (paramHub) ->
        SessionSettings.hub_attributes = paramHub
        $scope.hubFilter.hubFilter = SessionSettings.hub_attributes
    else if !$route.current.params.hub?
      $scope.hubFilter.hubFilter = null

  $scope.$watch 'hubFilter.hubFilter', ->
    if $scope.hubFilter.hubFilter == null
      $location.search('hub', null)
      SessionSettings.actions.hubFilter = 'All Groups'
    else if SessionSettings.hub_attributes.id?
      $location.path('/proposals').search('hub', SessionSettings.hub_attributes.id)
      SessionSettings.actions.hubFilter = SessionSettings.hub_attributes.group_name

  $scope.hubFilterSelect2 =
    minimumInputLength: 1
    placeholder: " Begin typing to find your Group or Location ... "
    width: '490px'
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
      if not _.isEmpty searchedHub
        SessionSettings.hub_attributes = searchedHub unless _.isEmpty searchedHub
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
      SessionSettings.actions.changeHub = 'new'
      currentHub = SessionSettings.hub_attributes
      SessionSettings.hub_attributes = {}
      SessionSettings.hub_attributes.location_id = currentHub.location_id
      SessionSettings.hub_attributes.formatted_location = currentHub.formatted_location
      if $scope.currentUser.id?
        VotingService.new $scope
      else
        $scope.authService.signinFb($scope).then ->
          VotingService.new $scope, VotingService
    angular.element('.select2-drop-active').select2 'close'
    angular.element('#newProposalHub').select2('data',null)

  $scope.newTopic = ->
    if $scope.sessionSettings.hub_attributes.id?
      $scope.sessionSettings.actions.changeHub = false
    else
      $scope.sessionSettings.actions.searchTerm = null
      $scope.sessionSettings.actions.changeHub = true
    if $scope.currentUser.id?
      VotingService.new $scope
    else
      $scope.authService.signinFb($scope).then ->
        VotingService.new $scope, VotingService

DashboardCtrl.$inject = [ '$scope', '$route', '$location', 'SessionSettings', 'CurrentHubLoader', 'VotingService' ]

App.controller 'DashboardCtrl', DashboardCtrl