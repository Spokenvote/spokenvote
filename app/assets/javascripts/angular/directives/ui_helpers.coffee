ngEnter =  ->
  (scope, element, attrs) ->
    element.bind "keydown keypress", (event) ->
      if event.which is 13
        scope.$apply ->
          scope.$eval attrs.ngEnter

        event.preventDefault()


autoGrow = ->
  (scope, element, attrs) ->
    update = ->
      if element[0].scrollWidth > element.outerWidth isBreaking = true else isBreaking = false
      element.css 'height', 'auto' if isBreaking
      height = element[0].scrollHeight
      element.css 'height', height + 'px'  if height > 0
    scope.$watch attrs.ngModel, update
    attrs.$set 'ngTrim', 'false'

# Register
App.Directives.directive 'ngEnter', ngEnter
App.Directives.directive 'autoGrow', autoGrow
