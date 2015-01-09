Focus = ($timeout, $log) ->
  (id) ->
    $timeout ->
      element = document.getElementById(id)
      element.focus()  if element

#      class_el = document.getElementsByClassName(id)
#      class_el.focus()  if element
#      $log.log class_el

# Register
App.Services.factory 'Focus', Focus