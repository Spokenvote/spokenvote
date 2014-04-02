DashboardCtrl = [ '$scope', '$route', '$location', 'CurrentHubLoader', ( $scope, $route, $location, CurrentHubLoader ) ->
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

    createSearchChoice: (term) ->
      if term.length > 2
        id: 'createNew'
        select_id: 'createNew'
        term: term
        full_hub: term + ' (Create New)'

    escapeMarkup: (m) ->
      m

    formatResult: (searchedHub) ->
      searchedHub.full_hub

    formatSelection: (searchedHub) ->
      if searchedHub.id is 'createNew'
        console.log searchedHub
        $scope.sessionSettings.actions.searchTerm = searchedHub.term
        currentHub = $scope.sessionSettings.hub_attributes
        $scope.sessionSettings.hub_attributes = {}
        $scope.sessionSettings.hub_attributes.location_id = currentHub.location_id
        $scope.sessionSettings.hub_attributes.formatted_location = currentHub.formatted_location
        angular.element('.select2-dropdown-open').select2 'close'
        angular.element('#newProposalHub').select2('data', null)
        if !$scope.currentUser.id?
          $scope.authService.signinFb($scope).then ->
            if !$scope.sessionSettings.openModals.newProposal and !$scope.sessionSettings.openModals.getStarted
              $scope.votingService.new()
            $scope.sessionSettings.actions.changeHub = 'new'
        else
          $scope.votingService.new() if !$scope.sessionSettings.openModals.newProposal and !$scope.sessionSettings.openModals.getStarted
          $scope.sessionSettings.actions.changeHub = 'new'
      else if not _.isEmpty searchedHub
        console.log 'else'
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
#      'No matches. If you are the first person to use this Group, <a id="navCreateHub" onclick="App.navCreateHub()" href="javascript:" >create it</a>.'
      'Not here? <a id="navCreateHub" onclick="App.navCreateHub()" href="javascript:" >Click here to create it</a>.'

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
      currentHub = $scope.sessionSettings.hub_attributes
      $scope.sessionSettings.hub_attributes = {}
      $scope.sessionSettings.hub_attributes.location_id = currentHub.location_id
      $scope.sessionSettings.hub_attributes.formatted_location = currentHub.formatted_location
      angular.element('.select2-dropdown-open').select2 'close'
      angular.element('#newProposalHub').select2('data', null)
      if !$scope.currentUser.id?
        $scope.authService.signinFb($scope).then ->
          if !$scope.sessionSettings.openModals.newProposal and !$scope.sessionSettings.openModals.getStarted
            $scope.votingService.new()
          $scope.sessionSettings.actions.changeHub = 'new'
      else
        $scope.votingService.new() if !$scope.sessionSettings.openModals.newProposal and !$scope.sessionSettings.openModals.getStarted
        $scope.sessionSettings.actions.changeHub = 'new'

  $scope.clearHubFilter = ->
    $scope.hubFilter.hubFilter = null

  $scope.tooltips =
    navMenu: 'Menu'
    backtoTopics: 'Return to Topic list'
    newTopic: 'Start a New Topic'

]

App.controller 'DashboardCtrl', DashboardCtrl