Focus = ($timeout) ->
  (id) ->
    $timeout ->
      element = angular.element id
      element.focus()  if element
#      console.log 'Focus Utility element: ', element

# Register
App.Services.factory 'Focus', Focus