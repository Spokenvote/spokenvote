ngEnter =  ->
  (scope, element, attrs) ->
    element.bind 'keydown keypress', (event) ->
      if event.which is 13
        scope.$apply ->
          scope.$eval attrs.ngEnter

        event.preventDefault()


autoGrow = ->
  (scope, element, attrs) ->
    update = ->
      if element[0].scrollWidth > element.outerWidth
        isBreaking = true
      else
        isBreaking = false
      element.css 'height', 'auto' if isBreaking
      height = element[0].scrollHeight
      element.css 'height', height + 'px'  if height > 0
    scope.$watch attrs.ngModel, update
    attrs.$set 'ngTrim', 'false'


uiSelectWrapper = ($timeout) ->
  link: (scope, element, attrs) ->
    uiSelectController = element.children().controller('uiSelect')
#    uiSelectController = element.children()
#    uiSelectController.kim = "hi"
#    console.log 'uiSelectWrapper Directive Log: ', uiSelectController
    $timeout ->
      uiSelectController
      console.log 'uiSelectWrapper Directive Log: ', uiSelectController
    , 550

#uiSelectWrapper = ($timeout) ->
#  restrict: "AE"
#  scope:
#    focus: "="
#
#  link: (scope, element, attrs) ->
#    uiSelectController = element.children().controller("uiSelect")
#    console.log 'uiSelectController Rosen: ', uiSelectController
#    if scope.focus
#      $timeout (->
#        uiSelectController.activate false, true
#      ), 50

uiselectAutofocus = ($timeout) ->            # not working as of Jan 30, 2015
  restrict: "A"
  require: "uiSelect"
  link: (scope, elem, attr) ->
    $timeout (->
      input = elem.find("input")
      console.log 'input: ', input
      input.click()  if attr.uiselectAutofocus is "open"
      input.focus()
    ), 4000



# Register
App.Directives.directive 'ngEnter', ngEnter
App.Directives.directive 'autoGrow', autoGrow
App.Directives.directive 'uiSelectWrapper', uiSelectWrapper
App.Directives.directive 'uiselectAutofocus', uiselectAutofocus
