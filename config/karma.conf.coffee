# Karma configuration

module.exports = (config) ->
  config.set
    basePath: "../"

    frameworks: [ "jasmine" ]

    files: [
      'vendor/assets/bower_components/underscore/underscore-min.js',
      'vendor/assets/bower_components/angular/angular.js',
      'vendor/assets/bower_components/angular-resource/angular-resource.js',
      'vendor/assets/bower_components/angular-route/angular-route.js',
      'vendor/assets/bower_components/angular-animate/angular-animate.js',
      'vendor/assets/bower_components/angular-cookies/angular-cookies.js',
      'vendor/assets/bower_components/angular-sanitize/angular-sanitize.js',
      'vendor/assets/bower_components/angular-loading-bar/build/loading-bar.min.js',
      'vendor/assets/bower_components/angular-ui-bootstrap/src/modal/modal.js',
      'vendor/assets/bower_components/angular-ui-bootstrap/src/transition/transition.js',
      'vendor/assets/bower_components/angular-ui-bootstrap/src/dropdownToggle/dropdownToggle.js',
      'vendor/assets/bower_components/angular-ui-bootstrap/src/tooltip/tooltip.js',
      'vendor/assets/bower_components/angular-ui-bootstrap/src/bindHtml/bindHtml.js',
      'vendor/assets/bower_components/angular-ui-bootstrap/src/position/position.js',
      'vendor/assets/bower_components/angular-ui-bootstrap/src/buttons/buttons.js',
      'vendor/assets/bower_components/angular-ui-utils/ui-utils.js',
      'vendor/assets/bower_components/angular-ui-select/dist/select.js',

# application
      'app/assets/javascripts/angular/*.coffee',
      'app/assets/javascripts/angular/**/*.coffee',

# mocks
      'vendor/assets/bower_components/angular-mocks/angular-mocks.js',
      'test/**/*mock.coffee',

# tests
      'test/**/*spec.coffee'
    ]

    coffeePreprocessor:
      options:
        sourceMap: true

    preprocessors:
      "app/assets/javascripts/angular/**/*.coffee": 'coffee'
      "test/**/*.coffee": 'coffee'

    coverageReporter:
      type: 'html'
      dir: 'coverage/'
      instrumenters:
        ibrik: require 'ibrik'

      instrumenter:
        "**/*.coffee": 'ibrik'

    reporters: [ "progress", "coverage" ]
    colors: true
    logLevel: config.LOG_DEBUG
#    autoWatch: true
#    browsers: [ "Chrome" ]
