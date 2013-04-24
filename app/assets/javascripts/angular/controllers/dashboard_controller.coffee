DashboardCtrl = ($scope, HubSelected, Proposal, HubProposals, HubProposalsServ) ->
  $scope.searchSelection = HubSelected
  $scope.model =
    message: "You have reached the Angular Route Provider :)"

  $scope.hubFilterSelect2 =
    minimumInputLength: 1
    placeholder: " Begin typing to find your Group or Location ..."
    width: '590px'
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
      HubSelected.id = item.id
      HubSelected.group_name = item.group_name
      $scope.hubProposals = Proposal.query
        hub: HubSelected.id
      item.full_hub

    formatNoMatches: (term) ->
      $scope.searchGroupTerm = term
      # TODO Below needs to be converted to an actual angular call
      'No matches. <a id="navCreateHub" onclick="angularApp.navCreateHub()" href="#">Create one</a>'

    initSelection: (element, callback) ->
      callback($scope.hubFilter.group_name)

  submitHubSearch = ->
    angular.copy($scope.hubProposals, HubProposals)

  angularApp.navCreateHub = ->
    angular.element("#s2id_hub_filter").select2 "close"
    angular.element("#hubModal").modal "show"
    # TODO This passing of $socpe.searchGroupTerm feels like a hack; let's pass it as an argument
    angular.element("#hubModal").find("#hub_group_name").val $scope.searchGroupTerm

  $scope.$watch('hubProposals', submitHubSearch, true)

DashboardCtrl.$inject = ['$scope', 'HubSelected', 'Proposal', 'HubProposals']
angularApp.controller 'DashboardCtrl', DashboardCtrl