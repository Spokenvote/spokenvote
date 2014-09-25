'use strict'

appConfig = ['$routeProvider', '$locationProvider', '$httpProvider', '$modalProvider', ($routeProvider, $locationProvider, $httpProvider, $modalProvider) ->

  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
  $locationProvider.html5Mode true

  $routeProvider
    .when( '/'
      title: 'Group Consensus Tool'
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
      title: 'Online Group Consensus Tool'
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
    .when( '/group-consensus-tool'
      title: 'Group Consensus Tool'
      templateUrl: 'pages/landing.html'
      callToAction: 'Group Consensus Tool'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.params.filter, $route.current.title
        ]
        setCallToAction: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setCallToAction $route.current.callToAction
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
          console.log '$route.current: ', $route.current
          $rootScope.page.setTitle $route.current.title, $route.current.params.proposalId
        ]
      )
#      .when '/currentuser',
#        resolve:
#          currentuser: [ 'CurrentUserLoader', (CurrentUserLoader) ->
#            CurrentUserLoader()
#          ]

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
      template: '<h3>Whoops, page not found</h3>'
      resolve:
        pageTitle: [ '$rootScope', '$route', ($rootScope, $route) ->
          $rootScope.page.setTitle $route.current.title
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
    'ui.select2', 'ui.utils',
    'ui.bootstrap.modal', 'ui.bootstrap.transition', 'ui.bootstrap.dropdownToggle', 'ui.bootstrap.tooltip'
    'spokenvote.services', 'spokenvote.directives',
]).config appConfig

servicesConfig = [ '$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push 'errorHttpInterceptor'
#  $httpProvider.responseInterceptors.push 'errorHttpInterceptor'
]

App.Services = angular.module('spokenvote.services', [ 'ngResource', 'ngCookies' ])
  .config(servicesConfig)
  .run( ['$rootScope', '$location', ($rootScope, $location) ->
    $rootScope.location = $location
    $rootScope.route =
      current: {}
    $rootScope.page =
      prefix: ''
      body: 'Online Group Consensus Tool' +  ' | '
      brand: 'Spokenvote'
      setTitle: (prefix, body) ->
        prefix = if prefix then prefix.charAt(0).toUpperCase() + prefix.substring(1) + ' | ' else @prefix
        body = if body then  body.charAt(0).toUpperCase() + body.substring(1) +  ' | ' else @body
        @title = prefix + body + @brand
      setCallToAction: (callToAction) ->
        @callToAction = callToAction
#      prerenderStatusCode: $route.current.prerenderStatusCode
  ])

App.Directives = angular.module 'spokenvote.directives', []


#Global Debug Functions
window.getSrv = (name, element) ->        # angular.element(document).injector() to get the current app injector
  element = element or "*[ng-app]"        # so, getSrv exposes the injector
  angular.element(element).injector().get name

window.getScope = (element) ->        # to get the current scope for the element
  angular.element(element).scope()

#angular.element(domElement).controller() # to get a hold of the ng-controller instance.
