DashboardCtrl = ($scope, $route, $location, SessionSettings, CurrentHubLoader, VotingService) ->
  $scope.changeCanvas = ->
    $scope.sessionSettings.actions.offcanvas = !$scope.sessionSettings.actions.offcanvas

  $scope.hubFilter =
    hubFilter: null

  SessionSettings.routeParams = $route.current.params

  if $route.current.params.hub? && !$route.current.params.proposalId? 
    $scope.hubFilter =
      hubFilter: true

  # needed to keep hub selection text box in sync if value of hubFilter changes
  $scope.$on '$locationChangeSuccess', ->
    if $route.current.params.hub? and ($scope.hubFilter.hubFilter is null or (String($scope.hubFilter.hubFilter.select_id) != String($route.current.params.hub)))
      CurrentHubLoader().then (paramHub) ->
        SessionSettings.hub_attributes = paramHub
        SessionSettings.hub_attributes.id = SessionSettings.hub_attributes.select_id
        $scope.hubFilter.hubFilter = SessionSettings.hub_attributes
    else if !$route.current.params.hub?
      $scope.hubFilter.hubFilter = null
 

  $scope.$watch 'hubFilter.hubFilter', ->
    if $scope.hubFilter.hubFilter == null
      $location.search('hub', null)
      SessionSettings.actions.hubFilter = 'All Groups'
    else if SessionSettings.hub_attributes.id? and SessionSettings.actions.selectHub == true
      SessionSettings.actions.selectHub = false 
      $location.path('/proposals').search('hub', SessionSettings.hub_attributes.id)
      SessionSettings.actions.hubFilter = SessionSettings.hub_attributes.short_hub

  $scope.hubFilterSelect2 =
    minimumInputLength: 1
    placeholder: "<i class='glyphicon glyphicon-search'></i>" + ' Find your Group or Location '
    width: '100%'
    allowClear: true
    ajax:
      url: "/hubs"
      dataType: "json"
      data: (term, page) ->
        hub_filter: term

      results: (data, page) ->
        results: data

    escapeMarkup: (m) ->
      m

    formatResult: (searchedHub) ->
      searchedHub.full_hub

    formatSelection: (searchedHub) ->
      if not _.isEmpty searchedHub
        SessionSettings.hub_attributes = searchedHub
        SessionSettings.actions.changeHub = false
        SessionSettings.actions.selectHub = true
        SessionSettings.hub_attributes.id = SessionSettings.hub_attributes.select_id
        $scope.hubFilter.hubFilter = searchedHub 
        searchedHub.full_hub

    formatNoMatches: (term) ->
      SessionSettings.actions.searchTerm = term
#      // The below sort of coded + injecting $compileProvider would be involved to move the "App." reference below inside of Angular; probably not worth trying to be that "pure"
#      $compile('No matches. If you are the first person to use this Group, please <button id="tempkim" ng-click="navCreateHub()" >create it</button>.')($scope)
      'No matches. If you are the first person to use this Group, <a id="navCreateHub" onclick="App.navCreateHub()" href="javascript:" >create it</a>.'

    id: (obj) ->
      obj.select_id 

    initSelection: (element, callback) ->
      if SessionSettings.actions.changeHub == "new"
        callback({})
      else
        CurrentHubLoader().then (searchedHub) ->
          if not _.isEmpty searchedHub 
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

  $scope.clearHubFilter = ->
     $scope.hubFilter.hubFilter = null

DashboardCtrl.$inject = [ '$scope', '$route', '$location', 'SessionSettings', 'CurrentHubLoader', 'VotingService' ]

App.controller 'DashboardCtrl', DashboardCtrl