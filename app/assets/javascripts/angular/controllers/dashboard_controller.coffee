DashboardCtrl = [ '$scope', '$route', '$location', 'SessionSettings', 'CurrentHubLoader', ( $scope, $route, $location, SessionSettings, CurrentHubLoader ) ->
  $scope.sessionSettings.routeParams = $route.current.params

  $scope.hubFilter =
    hubFilter: null

  if $route.current.params.hub? && !$route.current.params.proposalId? 
    $scope.hubFilter =
      hubFilter: true

  # needed to keep hub selection text box in sync if value of hubFilter changes
  $scope.$on '$locationChangeSuccess', ->
    if $route.current.params.hub? and ($scope.hubFilter.hubFilter is null or (String($scope.hubFilter.hubFilter.select_id) != String($route.current.params.hub)))
      CurrentHubLoader().then (paramHub) ->
        $scope.sessionSettings.hub_attributes = paramHub
        $scope.sessionSettings.hub_attributes.id = $scope.sessionSettings.hub_attributes.select_id
        $scope.hubFilter.hubFilter = $scope.sessionSettings.hub_attributes
    else if !$route.current.params.hub?
      $scope.hubFilter.hubFilter = null

  $scope.$watch 'hubFilter.hubFilter', ->
    if $scope.hubFilter.hubFilter == null
      $location.search('hub', null)
      $scope.sessionSettings.actions.hubFilter = 'All Groups'
    else if $scope.sessionSettings.hub_attributes.id? and $scope.sessionSettings.actions.selectHub == true
      $scope.sessionSettings.actions.selectHub = false
      $location.path('/proposals').search('hub', $scope.sessionSettings.hub_attributes.id)
      $scope.sessionSettings.actions.hubFilter = $scope.sessionSettings.hub_attributes.short_hub

  $scope.hubFilterSelect2 =
    minimumInputLength: 1
    placeholder: "<div class='fa fa-search'></div>" + "<span> Find your Group or Location</span>"
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
        $scope.sessionSettings.hub_attributes = searchedHub
        $scope.sessionSettings.actions.changeHub = false
        $scope.sessionSettings.actions.selectHub = true
        $scope.sessionSettings.hub_attributes.id = $scope.sessionSettings.hub_attributes.select_id
        $scope.hubFilter.hubFilter = searchedHub 
        searchedHub.full_hub

    formatNoMatches: (term) ->
      $scope.sessionSettings.actions.searchTerm = term
#      The below sort of coded + injecting $compileProvider would be involved to move the "App." reference below inside of Angular; probably not worth trying to be that "pure"
#      $compile('No matches. If you are the first person to use this Group, please <button id="tempkim" ng-click="navCreateHub()" >create it</button>.')($scope)
      'No matches. If you are the first person to use this Group, <a id="navCreateHub" onclick="App.navCreateHub()" href="javascript:" >create it</a>.'

    id: (obj) ->
      obj.select_id 

    initSelection: (element, callback) ->
      if $scope.sessionSettings.actions.changeHub == "new"
        callback({})
      else
        CurrentHubLoader().then (searchedHub) ->
          if not _.isEmpty searchedHub 
            $scope.sessionSettings.hub_attributes = searchedHub
          callback $scope.sessionSettings.hub_attributes

  App.navCreateHub = ->
    $scope.$apply ->
      $scope.sessionSettings.actions.changeHub = 'new'
      currentHub = $scope.sessionSettings.hub_attributes
      $scope.sessionSettings.hub_attributes = {}
      $scope.sessionSettings.hub_attributes.location_id = currentHub.location_id
      $scope.sessionSettings.hub_attributes.formatted_location = currentHub.formatted_location
      if !$scope.sessionSettings.openModals.newProposal and !$scope.sessionSettings.openModals.getStarted
        if $scope.currentUser.id?
          $scope.votingService.new $scope
        else
          $scope.authService.signinFb($scope).then ->
            $scope.votingService.new $scope
      angular.element('.select2-drop-active').select2 'close'
      angular.element('#newProposalHub').select2('data', null)

  $scope.tooltips =
    navMenu: 'Menu'
    backtoTopics: 'Return to Topic list'
    newTopic: 'Start a New Topic'

  # TODO Delete this code and move to a service
#  $scope.newTopic = ->
#    if $scope.sessionSettings.hub_attributes.id?
#      $scope.sessionSettings.actions.changeHub = false
#    else
#      $scope.sessionSettings.actions.searchTerm = null
#      $scope.sessionSettings.actions.changeHub = true
#    if $scope.currentUser.id?
#      VotingService.new $scope
#    else
#      $scope.authService.signinFb($scope).then ->
#        VotingService.new $scope, VotingService

  $scope.clearHubFilter = ->
     $scope.hubFilter.hubFilter = null

]

App.controller 'DashboardCtrl', DashboardCtrl