'use strict'

appConfig = ['$routeProvider', '$locationProvider', '$httpProvider', '$modalProvider', ($routeProvider, $locationProvider, $httpProvider, $modalProvider) ->

  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
  $locationProvider.html5Mode true

  $routeProvider
    .when( '/'
      title: 'Group Consensus Collaboration Tool'
      callToAction: 'Your Group Decisions'
      templateUrl: 'pages/landing.html'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
    )
    .when( '/landing'
      title: 'Group Consensus Voting Tool'
      templateUrl: 'pages/landing.html'
      callToAction: 'Your Group Decisions'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
    )
    .when( '/start'
      title: 'Group Consensus Voting Tool'
      templateUrl: 'pages/get_started.html'
      callToAction: 'Start Making Group Decisions'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
    )
     .when( '/home'
      title: 'Decision Platform'
      templateUrl: 'pages/landing.html'
      callToAction: 'Your Decision Platform'
      summary: "The Spokenvote decision platform gives groups a decision platform to reach consensus quickly and efficiently, from a decision platform for a local school board to a decision platform for an entire nation’s people. Spokenvote's decision platform radically enhances a group’s ability to reach consensus via an intuitive democratic process using a fun, efficient decision platform."
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
        setSummary: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setSummary $route.current.summary
        ]
    )
    .when( '/group-consensus-tool'
      title: 'Group Consensus Tool'
      templateUrl: 'pages/landing.html'
      callToAction: 'Group Consensus Tool'
      summary: "The Spokenvote group consensus tool gives groups a tool to reach consensus quickly and efficiently, from group consensus for a local school board to group consensus for an entire nation’s people. This group consensus tool radically enhances a group’s ability to reach consensus via an intuitive democratic process using a fun, efficient tool."
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
        setSummary: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setSummary $route.current.summary
        ]
    )
    .when( '/online-group-consensus-tool'
      title: 'Online Group Consensus Tool'
      templateUrl: 'pages/landing.html'
      callToAction: 'Online Group Consensus Tool'
      summary: "The Spokenvote online group consensus tool gives groups an online tool to reach consensus quickly and efficiently, from group consensus for a local school board to group consensus for an entire nation’s people. This online group consensus tool radically enhances a group’s ability to reach consensus online via an intuitive democratic process using a fun, efficient online tool."
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
        setSummary: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setSummary $route.current.summary
        ]
    )
    .when( '/voting-tool'
      title: 'Voting Tool'
      templateUrl: 'pages/landing.html'
      callToAction: 'Group Voting Tool'
      summary: "This group voting tool gives groups a voting tool to reach consensus quickly and efficiently. The voting tool works for consensus in groups like a local school board to consensus for an entire nation’s people. Spokenvote's voting tool radically enhances a group’s ability to reach consensus via an intuitive democratic process using a fun, efficient tool for voting."
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
        setSummary: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setSummary $route.current.summary
        ]
    )
    .when( '/reach-consensus'
      title: 'Reach Consensus'
      templateUrl: 'pages/landing.html'
      callToAction: 'Reach Consensus'
      summary: "Reach consensus quickly and efficiently. Spokenvote is a voting tool that lets you reach consensus in small groups, reach consensus in medium sized groups, or reach consensus for an entire nation’s people. Regardless, reaching consensus is radically enhanced by the group’s ability to reach consensus in an intuitive, democratic process using a fun, efficient voting tool."
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
        setSummary: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setSummary $route.current.summary
        ]
    )
    .when( '/group-consensus'
      title: 'Group Consensus'
      templateUrl: 'pages/landing.html'
      callToAction: 'Group Consensus'
      summary: "Group consensus: quick and efficient. Spokenvote is a voting tool for small group consensus, medium-sized group consensus, or group consensus for an entire nation’s people. Group consensus has never been easier. Radically enhanced group consensus is intuitive, democratic, and fun using this efficient group consensus tool."
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
        setSummary: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setSummary $route.current.summary
        ]
    )
    .when( '/collaborative-decision'
      title: 'Collaborative Decision'
      templateUrl: 'pages/landing.html'
      callToAction: 'Collaborative Decision'
      summary: "Quick and efficient collaborative decisions. Spokenvote is a voting tool for small collaborative decision, medium sized collaborative decision, or collaborative decision-making for an entire nation’s people. Collaborative decision has never been easier. Collaborative decisions become intuitive, democratic, and fun using this efficient collaborative decision tool."
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
        setSummary: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setSummary $route.current.summary
        ]
    )
    .when( '/proposals'
      title: 'Proposals'
      templateUrl: 'proposals/index.html'
      controller: 'ProposalListCtrl'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
    )
    .when( '/proposals/:proposalId'
      title: 'Proposal'
      templateUrl: 'proposals/show.html'
      controller: 'ProposalShowCtrl'
      resolve:
        proposal: [ 'ProposalLoader', (ProposalLoader) ->
          ProposalLoader()
        ]
        relatedProposals: [ 'RelatedProposalsLoader', (RelatedProposalsLoader) ->
          RelatedProposalsLoader()
        ]
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.title, $route.current.params.proposalId
        ]
      )
    .when( '/user-forum'
      title: 'User Forum'
      templateUrl: 'pages/user-forum.html'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.title
        ]
    )
    .when( '/dev-forum'
      title: 'Developer Forum'
      templateUrl: 'pages/dev-forum.html'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.title
        ]
    )
    .when( '/terms-of-use'
      title: 'Terms of Use'
      templateUrl: 'pages/terms-of-use.html'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.title
        ]
    )
    .when( '/privacy'
      title: 'Privacy Policy'
      templateUrl: 'pages/privacy.html'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.title
        ]
    )
    .otherwise(
      title: 'Lost in Space'
      prerenderStatusCode: '404'
      callToAction: 'Group Consensus Tool'
      summary: "The Spokenvote group consensus tool gives groups a tool to reach consensus quickly and efficiently, from group consensus for a local school board to group consensus for an entire nation’s people. This group consensus tool radically enhances a group’s ability to reach consensus via an intuitive democratic process using a fun, efficient tool."
      template: '<div class="call_to_action page_title">Whoops, {{ page.callToAction }} not found</div></br><h4 class="summary page_title">{{ page.summary }}</h4>'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
        ]
        setSummary: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setSummary $route.current.summary
        ]
    )

  $modalProvider.options =
    backdrop: true  # 'static' - backdrop is present but modal window is not closed when clicking outside of the modal window.
    keyboard: true
    windowClass: ''  # additional CSS class(es) to be added to a modal window template

  jQuery ->
    $('body').prepend('<div id="fb-root"></div>')

    $.ajax
      url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
      dataType: 'script'
      cache: true
]

window.App = angular.module('spokenvote', [
    'ngRoute', 'ngAnimate',
    'angular-loading-bar', 'templates',
    'ui.select2', 'ui.select', 'ui.utils',
    'ui.bootstrap.modal', 'ui.bootstrap.transition', 'ui.bootstrap.dropdownToggle', 'ui.bootstrap.tooltip', 'ui.bootstrap.buttons'
    'spokenvote.services', 'spokenvote.directives',
    'angulartics', 'angulartics.google.analytics'
]).config appConfig

servicesConfig = [ '$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push 'errorHttpInterceptor'
]

App.Services = angular.module('spokenvote.services', [ 'ngResource', 'ngCookies', 'ngSanitize' ])
  .config(servicesConfig)
  .run( ['$rootScope', '$location', '$log', ($rootScope, $location, $log) ->
    $rootScope.$log = $log
    $rootScope.location = $location
    $rootScope.route =
      current: {}
    $rootScope.page =
      prefix: ''
      body: 'Group Consensus Tool' +  ' | '
      brand: 'Spokenvote'
      setTitle: (prefix, body) ->
        prefix = if prefix then prefix.charAt(0).toUpperCase() + prefix.substring(1) + ' | ' else @prefix
        body = if body then  body.charAt(0).toUpperCase() + body.substring(1) +  ' | ' else @body
        @title = prefix + body + @brand
      setCallToAction: (callToAction) ->
        @callToAction = callToAction
      setSummary: (summary) ->
        @summary = summary
      metaDescription: undefined
  ])

App.Directives = angular.module 'spokenvote.directives', []


#Global Debug Functions
window.getSrv = (name, element) ->        # angular.element(document).injector() to get the current app injector
  element = element or "*[ng-app]"        # so, getSrv exposes the injector
  angular.element(element).injector().get name

window.getScope = (element) ->        # to get the current scope for the element
  angular.element(element).scope()

#angular.element(domElement).controller() # to get a hold of the ng-controller instance.
