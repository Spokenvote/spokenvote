DashboardCtrl = ($scope, $location, $dialog, SessionSettings, CurrentHubLoader, VotingService) ->
  $scope.hubFilter = {}
  $scope.hubFilter.full_hub = ' '

  $scope.$watch 'hubFilter.full_hub', ->
    if $scope.hubFilter.full_hub == null
      $location.search('hub', null)
      SessionSettings.hub_attributes.group_name = "All Groups"
    else if SessionSettings.hub_attributes.hub_id?
#      console.log "id" + SessionSettings.hub_attributes.hub_id
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
      item.full_hub

    formatNoMatches: (term) ->
      $scope.searchGroupTerm = term
#      // The below sort of coded + injecting $compileProvider would be involved to move the "App." reference below inside of Angular; probably not worth trying to be that "pure"
#      $compile('No matches. If you are the first person to use this Group, please <button id="tempkim" ng-click="navCreateHub()" >create it</button>.')($scope)
      'No matches. If you are the first person to use this Group, please <a id="navCreateHub" onclick="App.navCreateHub()" href="javascript:" >create it</a>.'

    initSelection: (element, callback) ->
#      console.log "init"
      CurrentHubLoader().then (searchedHub) ->
        SessionSettings.searchedHub = searchedHub
        $scope.hubFilter = searchedHub
        callback full_hub: SessionSettings.searchedHub.full_hub


  App.navCreateHub = ->
    $scope.$apply ->
      VotingService.new $scope
      SessionSettings.hub_attributes.changeHub = 'new'
    angular.element('.select2-drop-active').select2 'close'
#      if SessionSettings.user_actions.open_modal != 'newProposalModal'
#        concole.log "passed if"
#        SessionSettings.user_actions.open_modal = 'newProposalModal'
#        $scope.opts =
#          backdrop: true
#          keyboard: true
#          backdropClick: true
#          templateUrl: '/assets/proposals/_new_proposal_modal.html.haml'
#        d = $dialog.dialog($scope.opts)
#        d.open().then (result) ->
#          SessionSettings.user_actions.open_modal = false
#          console.log "dialog closed with result: " + SessionSettings.user_actions.open_modal
#      SessionSettings.hub_attributes.changeHub = 'new'
#      console.log SessionSettings.hub_attributes.changeHub

#    if SessionSettings.user_actions.open_modal != 'newProposalModal'
#      $scope.$apply ->
#        $modal
#          template: '/assets/hubs/_new_hub_modal.html.haml'
#          show: true
#          backdrop: 'static'
#          scope: $scope
#    $scope.$apply ->
#      SessionSettings.hub_attributes.changeHub = 'new'
#      console.log SessionSettings.hub_attributes.changeHub

DashboardCtrl.$inject = [ '$scope', '$location', '$dialog', 'SessionSettings', 'CurrentHubLoader', 'VotingService' ]
App.controller 'DashboardCtrl', DashboardCtrl