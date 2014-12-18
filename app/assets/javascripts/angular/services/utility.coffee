Focus = ($timeout) ->
  (id) ->
    $timeout ->
      element = document.getElementById(id)
      element.focus()  if element

# Register
App.Services.factory 'Focus', Focus