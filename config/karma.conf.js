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
//        'vendor/assets/bower_components/angulartics/dist/angulartics.min.js',     # not working
//        'vendor/assets/bower_components/angulartics/dist/angulartics-ga.min.js',  # https://github.com/luisfarzati/angulartics/issues/181

        // application
        'app/assets/javascripts/angular/*.coffee',
        'app/assets/javascripts/angular/**/*.coffee',
        //'app/assets/templates/**/*.html.slim',  // see http://codetunes.com/2014/karma-on-rails/
                                                  // Angular-Rails discussion: https://github.com/pitr/angular-rails-templates/issues/63#issuecomment-69788362
        // mocks
        'vendor/assets/bower_components/angular-mocks/angular-mocks.js',
        'test/**/*mock.coffee',

        // tests
        'test/**/*spec.coffee'
    ],

    // list of files to exclude
    exclude: [
//        'test/spec/z_use_later/**/*.*'
    ],

    coffeePreprocessor: {
      // options passed to the coffee compiler
      options: {
          //bare: true,      // Removed Jun 22, 2015
          sourceMap: true
      }
    },

    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      'app/assets/javascripts/angular/**/*.coffee': 'coffee',
      //'app/assets/javascripts/angular/**/*.coffee': 'coverage',   // Not working as of Jun 22, 2015
      'test/**/*.coffee': 'coffee'
      //'**/*.slim': ['slim', 'ng-html2js']     // see http://codetunes.com/2014/karma-on-rails/
    },

    coverageReporter: {
      type: 'text-summary',
      instrumenters: {
          ibrik: require('ibrik')
      },
      instrumenter: {
          '**/*.coffee': 'ibrik'
      }
    },

    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress', 'coverage'],

    //plugins: [require('../../lib/index'), 'karma-coffee-preprocessor'],
    //plugins: [require('../../lib/index'), 'karma-mocha', 'karma-coffee-preprocessor', 'karma-firefox-launcher'],
    //plugins: [
    //  'karma-jasmine',
    //  //'karma-coverage',
    //  'karma-coffee-preprocessor',
    //  'karma-phantomjs-launcher',
    //  'karma-chrome-launcher'
    //],


      // transforming the filenames             // Disabled Jun 22, 2015
      //transformPath: function(path) {
      //    return path.replace(/\.coffee$/, '.js');
      //},


      //ngHtml2JsPreprocessor: {                   // see http://codetunes.com/2014/karma-on-rails/
      //    stripPrefix: 'app/assets/templates/',
      //    stripSufix: '.slim'
      //},

    // web server port     // Disabled Jun 22, 2015
    //port: 8080,
//    port: 9876,

    // enable / disable colors in the output (reporters and logs)
    colors: true,

    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_DEBUG,
//    logLevel: config.LOG_INFO,

//    'client.captureConsole': true,

    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,

    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
//    browsers: ['Chrome'],
    browsers: ['Chrome', 'PhantomJS']
//    browsers: ['Chrome', 'PhantomJS_custom'],
//    browsers: ['Chrome', 'PhantomJS', 'PhantomJS_custom'],
//    browsers: ['Chrome', 'Firefox'],

      // Disabled Jun 22, 2015
    //customLaunchers: {
    //  'PhantomJS_custom': {
    //      base: 'PhantomJS',
    //      options: {
    //          windowName: 'Spokenvote PhantomJS',
    //          settings: {
    //              webSecurityEnabled: false
    //          }
    //      },
    //      flags: ['--remote-debugger-port=9000']
    //  }
    //}

    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
//    singleRun: false

  });
};
