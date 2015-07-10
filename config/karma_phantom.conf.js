// Karma configuration
// Generated on Tue Aug 26 2014 17:39:10 GMT-0700 (PDT)

module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '../',

    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine'],

    // list of files / patterns to load in the browser
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

        // application
        'app/assets/javascripts/angular/*.coffee',
        'app/assets/javascripts/angular/**/*.coffee',

        // mocks
        'vendor/assets/bower_components/angular-mocks/angular-mocks.js',
        'test/**/*mock.coffee',

        // tests
        'test/**/*spec.coffee'
    ],

    // list of files to exclude
    exclude: [
    ],

    coffeePreprocessor: {
      // options passed to the coffee compiler
      options: {
          sourceMap: true
      }
    },

    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      'app/assets/javascripts/angular/**/*.coffee': 'coffee',
      'test/**/*.coffee': 'coffee'
    },

    reporters: ['progress', 'coverage'],

    // enable / disable colors in the output (reporters and logs)
    colors: true,

    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_DEBUG,

    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['PhantomJS']

  });
};
