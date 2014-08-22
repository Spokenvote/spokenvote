'use strict'

appConfig = ['$routeProvider', '$locationProvider', '$httpProvider', '$modalProvider', ($routeProvider, $locationProvider, $httpProvider, $modalProvider) ->
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'

  $locationProvider.html5Mode true

  $routeProvider
    .when '/',
      title: 'Online Group Consensus Tool',
      templateUrl: 'pages/landing.html'

    .when '/landing',
      title: 'Online Group Consensus Tool',
      templateUrl: 'pages/landing.html'

    .when '/admin/authentications',
      controller: 'RootCtrl'

    .when '/proposals',
      title: 'Online Group Consensus Tool',
      templateUrl: 'proposals/index.html'
      controller: 'ProposalListCtrl'

    .when '/proposals/:proposalId',
      title: 'Online Group Consensus Tool',
      templateUrl: 'proposals/show.html'
      controller: 'ProposalShowCtrl'
      resolve:
        proposal: [ 'ProposalLoader', (ProposalLoader) ->
          ProposalLoader()
        ]
        relatedProposals: [ 'RelatedProposalsLoader', (RelatedProposalsLoader) ->
          RelatedProposalsLoader()
        ]

    .when '/currentuser',
      resolve:
        currentuser: [ 'CurrentUserLoader', (CurrentUserLoader) ->
          CurrentUserLoader()
        ]

    .when '/user-forum',
      title: 'User Forum for the Online Group Consensus Tool',
      templateUrl: 'pages/user-forum.html'

    .when '/dev-forum',
      title: 'Developer Forum for the Online Group Consensus Tool',
      templateUrl: 'pages/dev-forum.html'

    .when '/terms-of-use',
      title: 'Terms of use for your Online Group Consensus Tool',
      templateUrl: 'pages/terms-of-use.html'

    .when '/privacy',
      title: 'Privacy Notice for your Online Group Consensus Tool',
      templateUrl: 'pages/privacy.html'

    .otherwise
      title: 'Lost in Space for the Online Group Consensus Tool',
      template: '<h3>Whoops, page not found</h3>'

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

window.App = angular.module('spokenvote',
  [ 'ngRoute', 'angular-loading-bar', 'ngAnimate', 'spokenvote.services', 'spokenvote.directives', 'templates', 'ui', 'ui.bootstrap' ])
  .config(appConfig)

servicesConfig = ['$httpProvider', ($httpProvider) ->
  $httpProvider.responseInterceptors.push('errorHttpInterceptor')
]
App.Services = angular.module('spokenvote.services', ['ngResource', 'ngCookies'])
  .config(servicesConfig)
  .run(['$rootScope', '$location', ($rootScope, $location) ->
    $rootScope.location = $location
    $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
      $rootScope.title = current.$$route.title
  ])

App.Directives = angular.module('spokenvote.directives', [])


#Global Debug Functions
window.getSrv = (name, element) ->        # angular.element(document).injector() to get the current app injector
  element = element or "*[ng-app]"        # so, getSrv exposes the injector
  angular.element(element).injector().get name

window.getScope = (element) ->        # to get the current scope for the element
  angular.element(element).scope()

#angular.element(domElement).controller() # to get a hold of the ng-controller instance.
