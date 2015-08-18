
svUtility = ['$timeout', ($timeout) ->
  focus: (id) ->
    $timeout ->
      element = angular.element( document.querySelector id )
      element[0].focus()  if element
    ,
      10
]
# Register
App.Services.factory 'svUtility', svUtility