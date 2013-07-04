DashboardCtrl = ($scope, $route, $location, SessionSettings, CurrentHubLoader, VotingService, Omniauth, $window) ->
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
        console.log SessionSettings.hub_attributes
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


  $scope.devise = ->
    user =
#      action: 'google_oauth2'
      auth:
        provider: 'google_oauth2'
        uid: $scope.user.id
        name: $scope.user.name
        email: $scope.user.email
        avatar_url: $scope.user.picture
        token: $scope.authToken.access_token


#    AlertService.clearAlerts()
    console.log user

    Omniauth.save(user
    ,  (response, status, headers, config) ->
      console.log response
#      $location.path('/proposals/' + response.id)
#      AlertService.setSuccess 'Your improved proposal stating: \"' + response.statement + '\" was created.', $scope, 'main'
      dialog.close(response)
    ,  (response, status, headers, config) ->
#      AlertService.setCtlResult 'Sorry, your improved proposal was not saved.', $scope, 'modal'
#      AlertService.setJson response.data
    )


  $scope.auth = ->
    config =
      client_id: "390524033908-kqnb56kof2vfr4gssi2q84nth2n981g5"
#      scope: "https://www.googleapis.com/auth/urlshortener"
      scope: [ "https://www.googleapis.com/auth/plus.login",
       "https://www.googleapis.com/auth/plus.me",
       "https://www.googleapis.com/auth/userinfo.email",
       "https://www.googleapis.com/auth/userinfo.profile" ]
#      immediate: false

    gapi.auth.authorize config, ->
      console.log "login complete"
      console.log gapi.auth.getToken()
      $scope.authToken = gapi.auth.getToken()

  appendResults = (text) ->
    results = document.getElementById("results")
    results.appendChild document.createElement("P")
    results.appendChild document.createTextNode(text)

  makeRequest = ->
    console.log 'makeRequest'
    gapi.client.setApiKey "zOdnz-mMN26D4kzMnRKAeG_O"
    request = gapi.client.urlshortener.url.get(shortUrl: "http://goo.gl/fbsS")
    request.execute (response) ->
      appendResults response.longUrl

  $scope.makeApiCall = ->
    gapi.client.load "oauth2", "v2", ->
#      request = gapi.client.plus.people.get(userId: "me")
      request = gapi.client.oauth2.userinfo.get(userId: "me")
      request.execute (resp) ->
        $scope.user = resp
        console.log resp
        console.log gapi.auth.getToken()



#        heading = document.createElement("h4")
#        image = document.createElement("img")
#        console.log resp
##        image.src = resp.image.url
#        heading.appendChild image
#        heading.appendChild document.createTextNode(resp.displayName)
#        document.getElementById("content").appendChild heading

  $scope.externalLink = (href) ->
    $window.location.href = href


DashboardCtrl.$inject = [ '$scope', '$route', '$location', 'SessionSettings', 'CurrentHubLoader', 'VotingService', 'Omniauth', '$window' ]

App.controller 'DashboardCtrl', DashboardCtrl