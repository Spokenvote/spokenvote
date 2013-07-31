// Karma configuration
// Generated on Fri Jul 26 2013 17:19:22 GMT-0700 (PDT)


// base path, that will be used to resolve files and exclude
basePath = '../';


// list of files / patterns to load in the browser
files = [
  JASMINE,
  JASMINE_ADAPTER,
//  ANGULAR_SCENARIO,
//  ANGULAR_SCENARIO_ADAPTER,
  'vendor/assets/javascripts/jquery-2.0.3.min.js',
  'vendor/assets/javascripts/angular.min.js',
  'vendor/assets/javascripts/angular-resource.min.js',
  'vendor/assets/javascripts/angular-cookies.js',
  'vendor/assets/javascripts/angular-strap.js',
  'vendor/assets/javascripts/angular-ui.js',
  'vendor/assets/javascripts/ui-bootstrap-tpls-0.4.0.js',
  'vendor/assets/javascripts/angular-mocks.js',
//  'app/assets/javascripts/application.js',
  'app/assets/javascripts/angular/*.coffee.erb',
  'app/assets/javascripts/angular/**/*.coffee',
  'test/**/*spec.coffee'
];


// list of files to exclude
exclude = [
  
];

proxies = {'/': 'http://localhost:8000/test/spec/controllers/'};

urlRoot = '/_karma_/';

preprocessors = {
    '**/*.coffee': 'coffee',
    '**/*.coffee.erb': 'coffee'
};

// test results reporter to use
// possible values: 'dots', 'progress', 'junit'
reporters = ['progress'];


// web server port
port = 9876;


// cli runner port
runnerPort = 9100;


// enable / disable colors in the output (reporters and logs)
colors = true;


// level of logging
// possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
logLevel = LOG_INFO;


// enable / disable watching file and executing tests whenever any file changes
autoWatch = true;


// Start these browsers, currently available:
// - Chrome
// - ChromeCanary
// - Firefox
// - Opera
// - Safari (only Mac)
// - PhantomJS
// - IE (only Windows)
browsers = ['Chrome'];


// If browser does not capture in given timeout [ms], kill it
captureTimeout = 60000;


// Continuous Integration mode
// if true, it capture browsers, run tests and exit
singleRun = false;
