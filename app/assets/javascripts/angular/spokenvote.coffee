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
      controller: 'RootCtrl'

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

window.App = angular.module('spokenvote', [ 'ngRoute', 'spokenvote.services', 'spokenvote.directives', 'ui', 'ui.bootstrap' ]).config(appConfig)

servicesConfig = ['$httpProvider', ($httpProvider) ->
  $httpProvider.responseInterceptors.push('errorHttpInterceptor')
]
App.Services = angular.module('spokenvote.services', ['ngResource', 'ngCookies']).config(servicesConfig).run(['$rootScope', '$location', ($rootScope, $location) -> $rootScope.location = $location])

App.Directives = angular.module('spokenvote.directives', [])


# Add 2 Home iPhone script variables
window.addToHomeConfig =
  autostart: true			    # Automatically open the balloon
  returningVisitor: false	# Show the balloon to returning visitors only (setting this to true is highly recommended)
  animationIn: 'drop'		  # drop || bubble || fade
  animationOut: 'fade'		# drop || bubble || fade
  startDelay: 2000			  # 2 seconds from page load before the balloon appears
  lifespan: 15000			    # 15 seconds before it is automatically destroyed
  bottomOffset: 14			  # Distance of the balloon from bottom
  expire: 720					    # Minutes to wait before showing the popup again (0 = always displayed)
  message: ''				      # Customize your message or force a language ('' = automatic)
  touchIcon: false			  # Display the touch icon
  arrow: true				      # Display the balloon arrow
  hookOnLoad: true			  # Should we hook to onload event? (really advanced usage)
  closeButton: true			  # Let the user close the balloon
  iterations: 100				  # Internal/debug use


#Global Debug Functions
window.getSrv = (name, element) ->        # angular.element(document).injector() to get the current app injector
  element = element or "*[ng-app]"
  angular.element(element).injector().get name

window.getScope = (element) ->        # to get the current scope for the element
  angular.element(element).scope()

#angular.element(domElement).controller() # to get a hold of the ng-controller instance.
