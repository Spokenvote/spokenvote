###
AngularStrap - Twitter Bootstrap directives for AngularJS
@version v0.7.1 - 2013-03-21
@link http://mgcrea.github.com/angular-strap
@author Olivier Louvignes <olivier@mg-crea.com>
@license MIT License, http://www.opensource.org/licenses/MIT
###
angular.module("$strap.config", []).value "$strap.config", {}
angular.module "$strap.filters", ["$strap.config"]
angular.module "$strap.directives", ["$strap.config"]
angular.module "$strap", ["$strap.filters", "$strap.directives", "$strap.config"]
angular.module("$strap.directives").directive "bsAlert", ["$parse", "$timeout", "$compile", ($parse, $timeout, $compile) ->
  "use strict"
  restrict: "A"
  link: postLink = (scope, element, attrs) ->
    getter = $parse(attrs.bsAlert)
    setter = getter.assign
    value = getter(scope)

    # For static alerts
    unless attrs.bsAlert

      # Setup close button
      element.prepend "<button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button>"  if angular.isUndefined(attrs.closeButton) or (attrs.closeButton isnt "0" and attrs.closeButton isnt "false")
    else
      scope.$watch attrs.bsAlert, ((newValue, oldValue) ->
        value = newValue

        # Set alert content
        element.html ((if newValue.title then "<strong>" + newValue.title + "</strong>&nbsp;" else "")) + newValue.content or ""
        element.hide()  unless not newValue.closed

        # Compile alert content
        #$timeout(function(){
        $compile(element.contents()) scope

        #});

        # Add proper class
        if newValue.type or oldValue.type
          oldValue.type and element.removeClass("alert-" + oldValue.type)
          newValue.type and element.addClass("alert-" + newValue.type)

        # Setup close button
        element.prepend "<button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button>"  if angular.isUndefined(attrs.closeButton) or (attrs.closeButton isnt "0" and attrs.closeButton isnt "false")
      ), true
    element.addClass("alert").alert()

    # Support fade-in effect
    if element.hasClass("fade")
      element.removeClass "in"
      setTimeout ->
        element.addClass "in"

    parentArray = attrs.ngRepeat and attrs.ngRepeat.split(" in ").pop()
    element.on "close", (ev) ->
      removeElement = undefined
      if parentArray # ngRepeat, remove from parent array
        ev.preventDefault()
        element.removeClass "in"
        removeElement = ->
          element.trigger "closed"
          if scope.$parent
            scope.$parent.$apply ->
              path = parentArray.split(".")
              curr = scope.$parent
              i = 0

              while i < path.length
                curr = curr[path[i]]  if curr
                ++i
              curr.splice scope.$index, 1  if curr


        (if $.support.transition and element.hasClass("fade") then element.on($.support.transition.end, removeElement) else removeElement())
      else if value # object, set closed property to 'true'
        ev.preventDefault()
        element.removeClass "in"
        removeElement = ->
          element.trigger "closed"
          scope.$apply ->
            value.closed = true


        (if $.support.transition and element.hasClass("fade") then element.on($.support.transition.end, removeElement) else removeElement())
      else # static, regular behavior

]

# If we have a controller (i.e. ngModelController) then wire it up

# Set as single toggler if not part of a btn-group

# Handle start state

# Watch model for changes

# Handle $q promises

# Support buttons without .btn class

# Initialize button

# Bootstrap override to handle toggling

#Provide scope display functions
#      scope._button = function(event) {
#        element.button(event);
#      };
#      scope.loading = function() {
#        element.tooltip('loading');
#      };
#      scope.reset = function() {
#        element.tooltip('reset');
#      };
#
#      if(attrs.loadingText) element.click(function () {
#        //var btn = $(this)
#        element.button('loading')
#        setTimeout(function () {
#        element.button('reset')
#        }, 1000)
#      });
angular.module("$strap.directives").directive("bsButton", ["$parse", "$timeout", ($parse, $timeout) ->
  "use strict"
  restrict: "A"
  require: "?ngModel"
  link: postLink = (scope, element, attrs, controller) ->
    if controller
      element.attr "data-toggle", "button"  unless element.parent("[data-toggle=\"buttons-checkbox\"], [data-toggle=\"buttons-radio\"]").length
      startValue = !!scope.$eval(attrs.ngModel)
      element.addClass "active"  if startValue
      scope.$watch attrs.ngModel, (newValue, oldValue) ->
        bNew = !!newValue
        bOld = !!oldValue
        if bNew isnt bOld
          $.fn.button.Constructor::toggle.call button
        else element.addClass "active"  if bNew and not startValue

    unless element.hasClass("btn")
      element.on "click.button.data-api", (e) ->
        element.button "toggle"

    element.button()
    button = element.data("button")
    button.toggle = ->
      return $.fn.button.Constructor::toggle.call(this)  unless controller
      $parent = element.parent("[data-toggle=\"buttons-radio\"]")
      if $parent.length
        element.siblings("[ng-model]").each (k, v) ->
          $parse($(v).attr("ng-model")).assign scope, false

        scope.$digest()
        unless controller.$modelValue
          controller.$setViewValue not controller.$modelValue
          scope.$digest()
      else
        scope.$apply ->
          controller.$setViewValue not controller.$modelValue

]).directive("bsButtonsCheckbox", ["$parse", ($parse) ->
  "use strict"
  restrict: "A"
  require: "?ngModel"
  compile: compile = (tElement, tAttrs, transclude) ->
    tElement.attr("data-toggle", "buttons-checkbox").find("a, button").each (k, v) ->
      $(v).attr "bs-button", ""

]).directive "bsButtonsRadio", ["$parse", ($parse) ->
  "use strict"
  restrict: "A"
  require: "?ngModel"
  compile: compile = (tElement, tAttrs, transclude) ->
    tElement.attr "data-toggle", "buttons-radio"

    # Delegate to children ngModel
    unless tAttrs.ngModel
      tElement.find("a, button").each (k, v) ->
        $(v).attr "bs-button", ""

    postLink = (scope, iElement, iAttrs, controller) ->

      # If we have a controller (i.e. ngModelController) then wire it up
      if controller
        iElement.find("[value]").button().filter("[value=\"" + scope.$eval(iAttrs.ngModel) + "\"]").addClass "active"
        iElement.on "click.button.data-api", (ev) ->
          scope.$apply ->
            controller.$setViewValue $(ev.target).closest("button").attr("value")



        # Watch model for changes
        scope.$watch iAttrs.ngModel, (newValue, oldValue) ->
          if newValue isnt oldValue
            $btn = iElement.find("[value=\"" + scope.$eval(iAttrs.ngModel) + "\"]")
            $.fn.button.Constructor::toggle.call $btn.data("button")  if $btn.length

]
angular.module("$strap.directives").directive "bsButtonSelect", ["$parse", "$timeout", ($parse, $timeout) ->
  "use strict"
  restrict: "A"
  require: "?ngModel"
  link: postLink = (scope, element, attrs, ctrl) ->
    getter = $parse(attrs.bsButtonSelect)
    setter = getter.assign

    # Bind ngModelController
    if ctrl
      element.text scope.$eval(attrs.ngModel)

      # Watch model for changes
      scope.$watch attrs.ngModel, (newValue, oldValue) ->
        element.text newValue


    # Click handling
    values = undefined
    value = undefined
    index = undefined
    newValue = undefined
    element.bind "click", (ev) ->
      values = getter(scope)
      value = (if ctrl then scope.$eval(attrs.ngModel) else element.text())
      index = values.indexOf(value)
      newValue = (if index > values.length - 2 then values[0] else values[index + 1])
      console.warn values, newValue
      scope.$apply ->
        element.text newValue
        ctrl.$setViewValue newValue  if ctrl


]

# https://github.com/eternicode/bootstrap-datepicker
angular.module("$strap.directives").directive "bsDatepicker", ["$timeout", "$strap.config", ($timeout, config) ->
  "use strict"
  isTouch = "ontouchstart" of window and not window.navigator.userAgent.match(/PhantomJS/i)
  regexpMap = regexpMap = (language) ->
    language = language or "en"
    "/": "[\\/]"
    "-": "[-]"
    ".": "[.]"
    " ": "[\\s]"
    dd: "(?:(?:[0-2]?[0-9]{1})|(?:[3][01]{1}))"
    d: "(?:(?:[0-2]?[0-9]{1})|(?:[3][01]{1}))"
    mm: "(?:[0]?[1-9]|[1][012])"
    m: "(?:[0]?[1-9]|[1][012])"
    DD: "(?:" + $.fn.datepicker.dates[language].days.join("|") + ")"
    D: "(?:" + $.fn.datepicker.dates[language].daysShort.join("|") + ")"
    MM: "(?:" + $.fn.datepicker.dates[language].months.join("|") + ")"
    M: "(?:" + $.fn.datepicker.dates[language].monthsShort.join("|") + ")"
    yyyy: "(?:(?:[1]{1}[0-9]{1}[0-9]{1}[0-9]{1})|(?:[2]{1}[0-9]{3}))(?![[0-9]])"
    yy: "(?:(?:[0-9]{1}[0-9]{1}))(?![[0-9]])"

  regexpForDateFormat = regexpForDateFormat = (format, language) ->
    re = format
    map = regexpMap(language)
    i = undefined

    # Abstract replaces to avoid collisions
    i = 0
    angular.forEach map, (v, k) ->
      re = re.split(k).join("${" + i + "}")
      i++


    # Replace abstracted values
    i = 0
    angular.forEach map, (v, k) ->
      re = re.split("${" + i + "}").join(v)
      i++

    new RegExp("^" + re + "$", ["i"])

  restrict: "A"
  require: "?ngModel"
  link: postLink = (scope, element, attrs, controller) ->
    options = config.datepicker or {}
    language = attrs.language or options.language or "en"
    format = attrs.dateFormat or options.format or ($.fn.datepicker.dates[language] and $.fn.datepicker.dates[language].format) or "mm/dd/yyyy"
    dateFormatRegexp = (if isTouch then "yyyy/mm/dd" else regexpForDateFormat(format, language))

    # Handle date validity according to dateFormat
    if controller
      controller.$parsers.unshift (viewValue) ->

        #console.warn('viewValue', viewValue, dateFormatRegexp,  dateFormatRegexp.test(viewValue));
        if not viewValue or dateFormatRegexp.test(viewValue)
          controller.$setValidity "date", true
          viewValue
        else
          controller.$setValidity "date", false
          `undefined`


    # Use native interface for touch devices
    if isTouch and element.prop("type") is "text"
      element.prop "type", "date"
      element.on "change", (ev) ->
        scope.$apply ->
          controller.$setViewValue element.val()


    else

      # If we have a controller (i.e. ngModelController) then wire it up
      if controller
        element.on "changeDate", (ev) ->
          scope.$apply ->
            controller.$setViewValue element.val()



      # Popover GarbageCollection
      $popover = element.closest(".popover")
      if $popover
        $popover.on "hide", (e) ->
          datepicker = element.data("datepicker")
          if datepicker
            datepicker.picker.remove()
            element.data "datepicker", null


      # Create datepicker
      element.attr "data-toggle", "datepicker"
      element.datepicker
        autoclose: true
        format: format
        language: language
        forceParse: attrs.forceParse or false


    # Support add-on
    component = element.siblings("[data-toggle=\"datepicker\"]")
    if component.length
      component.on "click", ->
        element.trigger "focus"

]

# https://github.com/eternicode/bootstrap-datepicker
angular.module("$strap.directives").directive "bsDaterangepicker", ["$timeout", ($timeout) ->
  "use strict"
  isTouch = "ontouchstart" of window and not window.navigator.userAgent.match(/PhantomJS/i)

  # var DATE_REGEXP_MAP = {
  #   '/'    : '[\\/]',
  #   '-'    : '[-]',
  #   '.'    : '[.]',
  #   'dd'   : '(?:(?:[0-2]?[0-9]{1})|(?:[3][01]{1}))',
  #   'd'   : '(?:(?:[0-2]?[0-9]{1})|(?:[3][01]{1}))',
  #   'mm'   : '(?:[0]?[1-9]|[1][012])',
  #   'm'   : '(?:[0]?[1-9]|[1][012])',
  #   'yyyy' : '(?:(?:[1]{1}[0-9]{1}[0-9]{1}[0-9]{1})|(?:[2]{1}[0-9]{3}))(?![[0-9]])',
  #   'yy'   : '(?:(?:[0-9]{1}[0-9]{1}))(?![[0-9]])'
  # };
  restrict: "A"
  require: "?ngModel"
  link: postLink = (scope, element, attrs, controller) ->
    console.log "postLink", this, arguments_
    window.element = element

    #   var regexpForDateFormat = function(dateFormat, options) {
    #     options || (options = {});
    #     var re = dateFormat, regexpMap = DATE_REGEXP_MAP;
    #     /*if(options.mask) {
    #       regexpMap['/'] = '';
    #       regexpMap['-'] = '';
    #     }*/
    #     angular.forEach(regexpMap, function(v, k) { re = re.split(k).join(v); });
    #     return new RegExp('^' + re + '$', ['i']);
    #   };

    #   var dateFormatRegexp = isTouch ? 'yyyy/mm/dd' : regexpForDateFormat(attrs.dateFormat || 'mm/dd/yyyy'/*, {mask: !!attrs.uiMask}*/);

    #   // Handle date validity according to dateFormat
    #   if(controller) {
    #     controller.$parsers.unshift(function(viewValue) {
    #       //console.warn('viewValue', viewValue, dateFormatRegexp,  dateFormatRegexp.test(viewValue));
    #       if (!viewValue || dateFormatRegexp.test(viewValue)) {
    #         controller.$setValidity('date', true);
    #         return viewValue;
    #       } else {
    #         controller.$setValidity('date', false);
    #         return undefined;
    #       }
    #     });
    #   }

    #   // Support add-on
    #   var component = element.next('[data-toggle="datepicker"]');
    #   if(component.length) {
    #     component.on('click', function() { isTouch ? element.trigger('focus') : element.datepicker('show'); });
    #   }

    #   // Use native interface for touch devices
    #   if(isTouch && element.prop('type') === 'text') {

    #     element.prop('type', 'date');
    #     element.on('change', function(ev) {
    #       scope.$apply(function () {
    #         controller.$setViewValue(element.val());
    #       });
    #     });

    #   } else {

    #     // If we have a controller (i.e. ngModelController) then wire it up
    #     if(controller) {
    #       element.on('changeDate', function(ev) {
    #         scope.$apply(function () {
    #           controller.$setViewValue(element.val());
    #         });
    #       });
    #     }

    #     // Popover GarbageCollection
    #     var $popover = element.closest('.popover');
    #     if($popover) {
    #       $popover.on('hide', function(e) {
    #         var datepicker = element.data('datepicker');
    #         if(datepicker) {
    #           datepicker.picker.remove();
    #           element.data('datepicker', null);
    #         }
    #       });
    #     }

    # Create daterangepicker
    element.attr "data-toggle", "daterangepicker"
    element.daterangepicker {}
]

# autoclose: true,
# forceParse: attrs.forceParse || false,
# language: attrs.language || 'en'

#   }
angular.module("$strap.directives").directive "bsDropdown", ["$parse", "$compile", "$timeout", ($parse, $compile, $timeout) ->
  "use strict"
  buildTemplate = (items, ul) ->
    ul = ["<ul class=\"dropdown-menu\" role=\"menu\" aria-labelledby=\"drop1\">", "</ul>"]  unless ul
    angular.forEach items, (item, index) ->
      return ul.splice(index + 1, 0, "<li class=\"divider\"></li>")  if item.divider
      li = "<li" + ((if item.submenu and item.submenu.length then " class=\"dropdown-submenu\"" else "")) + ">" + "<a tabindex=\"-1\" ng-href=\"" + (item.href or "") + "\"" + ((if item.click then "\" ng-click=\"" + item.click + "\"" else "")) + ((if item.target then "\" target=\"" + item.target + "\"" else "")) + ">" + (item.text or "") + "</a>"
      li += buildTemplate(item.submenu).join("\n")  if item.submenu and item.submenu.length
      li += "</li>"
      ul.splice index + 1, 0, li

    ul

  restrict: "EA"
  scope: true
  link: postLink = (scope, iElement, iAttrs) ->
    getter = $parse(iAttrs.bsDropdown)
    items = getter(scope)

    # Defer after any ngRepeat rendering
    $timeout ->
      angular.isArray(items)

      # @todo?
      dropdown = angular.element(buildTemplate(items).join(""))
      dropdown.insertAfter iElement

      # Compile dropdown-menu
      $compile(iElement.next("ul.dropdown-menu")) scope

    iElement.addClass("dropdown-toggle").attr "data-toggle", "dropdown"
]
angular.module("$strap.directives").directive "bsModal", ["$parse", "$compile", "$http", "$timeout", "$q", "$templateCache", ($parse, $compile, $http, $timeout, $q, $templateCache) ->
  "use strict"
  restrict: "A"
  scope: true
  link: postLink = (scope, element, attr, ctrl) ->
    getter = $parse(attr.bsModal)
    setter = getter.assign
    value = getter(scope)
    $q.when($templateCache.get(value) or $http.get(value,
                                                   cache: true
    )).then onSuccess = (template) ->

      # Handle response from $http promise
      template = template.data  if angular.isObject(template)

      # Build modal object
      id = getter(scope).replace(".html", "").replace(/[\/|\.|:]/g, "-") + "-" + scope.$id
      $modal = $("<div class=\"modal hide\" tabindex=\"-1\"></div>").attr("id", id).attr("data-backdrop", attr.backdrop or true).attr("data-keyboard", attr.keyboard or true).addClass((if attr.modalClass then "fade " + attr.modalClass else "fade")).html(template)
      $("body").append $modal

      # Configure element
      element.attr("href", "#" + id).attr "data-toggle", "modal"

      # Compile modal content
      $timeout ->
        $compile($modal) scope


      # Provide scope display functions
      scope._modal = (name) ->
        $modal.modal name

      scope.hide = ->
        $modal.modal "hide"

      scope.show = ->
        $modal.modal "show"

      scope.dismiss = scope.hide
      $modal.on "show", (event) ->
        scope.$emit "modal-show", event

      $modal.on "shown", (event) ->
        scope.$emit "modal-shown", event

      $modal.on "hide", (event) ->
        scope.$emit "modal-hide", event

      $modal.on "hidden", (event) ->
        scope.$emit "modal-hidden", event


]
angular.module("$strap.directives").directive "bsNavbar", ["$location", ($location) ->
  "use strict"
  restrict: "A"
  link: postLink = ($scope, element, attrs, controller) ->

    # Watch for the $location
    $scope.$watch (->
      $location.path()
                  ), (newValue, oldValue) ->
      element.find("li[data-match-route]").each (k, li) ->
        $li = angular.element(li)

        # data('match-rout') does not work with dynamic attributes
        pattern = $li.attr("data-match-route")
        regexp = new RegExp("^" + pattern + "$", ["i"])
        if regexp.test(newValue)
          $li.addClass "active"
        else
          $li.removeClass "active"


]
angular.module("$strap.directives").directive "bsPopover", ["$parse", "$compile", "$http", "$timeout", "$q", "$templateCache", ($parse, $compile, $http, $timeout, $q, $templateCache) ->
  "use strict"

  # Hide popovers when pressing esc
  $("body").on "keyup", (ev) ->
    if ev.keyCode is 27
      $(".popover.in").each ->
        $(this).popover "hide"


  restrict: "A"
  scope: true
  link: postLink = (scope, element, attr, ctrl) ->
    getter = $parse(attr.bsPopover)
    setter = getter.assign
    value = getter(scope)
    options = {}
    options = value  if angular.isObject(value)
    $q.when(options.content or $templateCache.get(value) or $http.get(value,
                                                                      cache: true
    )).then onSuccess = (template) ->

      # Handle response from $http promise
      template = template.data  if angular.isObject(template)

      # Handle data-unique attribute
      unless not attr.unique
        element.on "show", (ev) -> # requires bootstrap 2.3.0+
          # Hide any active popover except self
          $(".popover.in").each ->
            $this = $(this)
            popover = $this.data("popover")
            $this.popover "hide"  if popover and not popover.$element.is(element)



      # Handle data-hide attribute to toggle visibility
      unless not attr.hide
        scope.$watch attr.hide, (newValue, oldValue) ->
          unless not newValue
            popover.hide()
          else popover.show()  if newValue isnt oldValue


      # Initialize popover
      element.popover angular.extend({}, options,
                                     content: template
                                     html: true
      )

      # Bootstrap override to provide tip() reference & compilation
      popover = element.data("popover")
      popover.hasContent = ->
        @getTitle() or template # fix multiple $compile()

      popover.getPosition = ->
        r = $.fn.popover.Constructor::getPosition.apply(this, arguments_)

        # Compile content
        $compile(@$tip) scope
        scope.$digest()

        # Bind popover to the tip()
        @$tip.data "popover", this
        r


      # Provide scope display functions
      scope._popover = (name) ->
        element.popover name

      scope.hide = ->
        element.popover "hide"

      scope.show = ->
        element.popover "show"

      scope.dismiss = scope.hide

]
angular.module("$strap.directives").directive "bsTabs", ["$parse", "$compile", "$timeout", ($parse, $compile, $timeout) ->
  "use strict"
  restrict: "A"
  require: "?ngModel"
  scope: true
  link: postLink = (scope, iElement, iAttrs, controller) ->
    getter = $parse(iAttrs.bsTabs)
    setter = getter.assign
    value = getter(scope)
    tabs = ["<ul class=\"nav nav-tabs\">", "</ul>"]
    panes = ["<div class=\"tab-content\">", "</div>"]
    iElement.hide()
    activeTab = 0

    # Defer after any ngRepeat rendering
    $timeout ->
      unless angular.isArray(value)
        value = []

        # Convert existing dom elements
        iElement.children("[data-title], [data-tab]").each (index) ->
          $this = angular.element(this)
          value.push
            title: scope.$eval($this.data("title") or $this.data("tab"))
            content: @innerHTML
            active: $this.hasClass("active")
            fade: $this.hasClass("fade")



      # Select correct starting activeTab
      angular.forEach value, (tab, index) ->
        activeTab = index  if tab.active


      # Build from object
      angular.forEach value, (tab, index) ->
        id = "tab-" + scope.$id + "-" + index
        active = activeTab is index
        fade = iAttrs.fade or tab.fade
        tabs.splice index + 1, 0, "<li" + ((if active then " class=\"active\"" else "")) + "><a href=\"#" + id + "\" data-index=\"" + index + "\" data-toggle=\"tab\">" + tab.title + "</a></li>"
        panes.splice index + 1, 0, "<div class=\"tab-pane" + ((if active then " active" else "")) + ((if fade then " fade" else "")) + ((if fade and active then " in" else "")) + "\" id=\"" + id + "\">" + tab.content + "</div>"

      iElement.html(tabs.join("") + panes.join("")).show()

      # Compile tab-content
      $compile(iElement.children("div.tab-content")) scope


    # If we have a controller (i.e. ngModelController) then wire it up
    if controller
      iElement.on "show", (ev) ->
        $target = $(ev.target)
        scope.$apply ->
          controller.$setViewValue $target.data("index")



      # Watch ngModel for changes
      scope.$watch iAttrs.ngModel, (newValue, oldValue) ->
        return  if angular.isUndefined(newValue)
        activeTab = newValue # update starting activeTab before first build
        setTimeout ->
          $next = iElement.children("ul.nav-tabs").find("li:eq(" + newValue * 1 + ")")
          $next.children("a").tab "show"  unless $next.hasClass("active")


]
angular.module("$strap.directives").directive "bsTimepicker", ["$timeout", ($timeout) ->
  "use strict"
  TIME_REGEXP = "((?:(?:[0-1][0-9])|(?:[2][0-3])|(?:[0-9])):(?:[0-5][0-9])(?::[0-5][0-9])?(?:\\s?(?:am|AM|pm|PM))?)"
  restrict: "A"
  require: "?ngModel"
  link: postLink = (scope, element, attrs, controller) ->

    # If we have a controller (i.e. ngModelController) then wire it up
    if controller
      element.on "changeTime.timepicker", (ev) ->
        $timeout ->
          controller.$setViewValue element.val()



    # Handle input time validity
    timeRegExp = new RegExp("^" + TIME_REGEXP + "$", ["i"])
    controller.$parsers.unshift (viewValue) ->

      # console.warn('viewValue', viewValue, timeRegExp,  timeRegExp.test(viewValue));
      if not viewValue or timeRegExp.test(viewValue)
        controller.$setValidity "time", true
        viewValue
      else
        controller.$setValidity "time", false
        return


    # Create datepicker
    element.attr "data-toggle", "timepicker"
    element.parent().addClass "bootstrap-timepicker"

    #$timeout(function () {
    element.timepicker()
]

#});
angular.module("$strap.directives").directive "bsTooltip", ["$parse", "$compile", ($parse, $compile) ->
  "use strict"
  restrict: "A"
  scope: true
  link: postLink = (scope, element, attrs, ctrl) ->
    getter = $parse(attrs.bsTooltip)
    setter = getter.assign
    value = getter(scope)

    # Watch bsTooltip for changes
    scope.$watch attrs.bsTooltip, (newValue, oldValue) ->
      value = newValue  if newValue isnt oldValue

    unless not attrs.unique
      element.on "show", (ev) ->

        # Hide any active popover except self
        $(".tooltip.in").each ->
          $this = $(this)
          tooltip = $this.data("tooltip")
          $this.tooltip "hide"  if tooltip and not tooltip.$element.is(element)



    # Initialize tooltip
    element.tooltip
      title: ->
        (if angular.isFunction(value) then value.apply(null, arguments_) else value)

      html: true


    # Bootstrap override to provide events & tip() reference
    tooltip = element.data("tooltip")
    tooltip.show = ->
      r = $.fn.tooltip.Constructor::show.apply(this, arguments_)

      # Bind tooltip to the tip()
      @tip().data "tooltip", this
      r


    #Provide scope display functions
    scope._tooltip = (event) ->
      element.tooltip event

    scope.hide = ->
      element.tooltip "hide"

    scope.show = ->
      element.tooltip "show"

    scope.dismiss = scope.hide
]
angular.module("$strap.directives").directive "bsTypeahead", ["$parse", ($parse) ->
  "use strict"
  restrict: "A"
  require: "?ngModel"
  link: postLink = (scope, element, attrs, controller) ->
    getter = $parse(attrs.bsTypeahead)
    setter = getter.assign
    value = getter(scope)

    # Watch bsTypeahead for changes
    scope.$watch attrs.bsTypeahead, (newValue, oldValue) ->
      value = newValue  if newValue isnt oldValue

    element.attr "data-provide", "typeahead"
    element.typeahead
      source: (query) ->
        (if angular.isFunction(value) then value.apply(null, arguments_) else value)

      minLength: attrs.minLength or 1
      items: attrs.items
      updater: (value) ->

        # If we have a controller (i.e. ngModelController) then wire it up
        if controller
          scope.$apply ->
            controller.$setViewValue value

        value


    # Bootstrap override
    typeahead = element.data("typeahead")

    # Fixes #2043: allows minLength of zero to enable show all for typeahead
    typeahead.lookup = (ev) ->
      items = undefined
      @query = @$element.val() or ""
      return (if @shown then @hide() else this)  if @query.length < @options.minLength
      items = (if $.isFunction(@source) then @source(@query, $.proxy(@process, this)) else @source)
      (if items then @process(items) else this)


    # Support 0-minLength
    if attrs.minLength is "0"
      setTimeout -> # Push to the event loop to make sure element.typeahead is defined (breaks tests otherwise)
        element.on "focus", ->
          element.val().length is 0 and setTimeout(element.typeahead.bind(element, "lookup"), 200)


]