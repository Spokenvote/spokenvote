'use strict'

appConfig = ['$routeProvider', '$locationProvider', '$httpProvider', '$modalProvider', ($routeProvider, $locationProvider, $httpProvider, $modalProvider) ->
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'

  $locationProvider.html5Mode true

  $routeProvider
    .when '/',
      templateUrl: '/assets/pages/landing.html'

    .when '/admin/authentications',
      controller: 'RootCtrl'

    .when '/landing',
      templateUrl: '/assets/pages/landing.html'

    .when '/proposals',
      templateUrl: '/assets/proposals/index.html'
      controller: 'ProposalListCtrl'
      resolve:
        proposals: [ 'MultiProposalLoader', (MultiProposalLoader) ->
          MultiProposalLoader()
        ]
    .when '/proposals/:proposalId',
      templateUrl: '/assets/proposals/show.html'
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

    .when '/about',
      templateUrl: '/assets/pages/about.html'

    .when '/terms-of-use',
      templateUrl: '/assets/pages/terms-of-use.html'

    .when '/privacy',
      templateUrl: '/assets/pages/privacy.html'

    .otherwise
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

window.App = angular.module('spokenvote', [ 'ngRoute', 'spokenvote.services', 'spokenvote.directives', 'templates', 'ui', 'ui.bootstrap' ]).config(appConfig)

servicesConfig = ['$httpProvider', ($httpProvider) ->
  $httpProvider.responseInterceptors.push('errorHttpInterceptor')
]
App.Services = angular.module('spokenvote.services', ['ngResource', 'ngCookies']).config(servicesConfig).run(['$rootScope', '$location', ($rootScope, $location) -> $rootScope.location = $location])

App.Directives = angular.module('spokenvote.directives', [])


#Global Debug Functions
window.getSrv = (name, element) ->        # angular.element(document).injector() to get the current app injector
  element = element or "*[ng-app]"
  angular.element(element).injector().get name

window.getScope = (element) ->        # to get the current scope for the element
  angular.element(element).scope()

#angular.element(domElement).controller() # to get a hold of the ng-controller instance.
