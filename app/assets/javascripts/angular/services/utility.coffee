Focus = ($timeout) ->
  (id) ->
    $timeout ->
      element = angular.element( document.querySelector id )
      element[0].focus()  if element
#      console.log 'Focus Utility element: ', element

# Register
App.Services.factory 'Focus', Focus