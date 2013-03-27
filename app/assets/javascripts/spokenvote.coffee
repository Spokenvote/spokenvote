window.app = {}
(->

# TODO *** JS CONVERTED TO COFFEESCRIPT FOR EASIER READING AND REFERENCE *** ... Will over the coming months be refactored into assets/javascripts/angular directories and then depreciated

# MOVED LOGIC TO ALERTS SERVICES
#  app.createAlert = (msg, style) ->
#    $("#alertContainer").before "<div class=\"alert alert-" + style + "\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\">&times;</a>" + msg + "</div>"
#
#  app.createModalAlert = (msg, style, modalElem) ->
#    $(modalElem).find(".modal-body div").first().prepend "<div class=\"alert alert-" + style + "\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\">&times;</a>" + msg + "</div>"
#
#  app.successMessage = (msg) ->
#    app.createAlert msg, "success"
#
#  app.errorMessage = (msg) ->
#    app.createAlert msg, "error"
#
#  app.closeAlert = (e) ->
#    return  if $(".alert").length is 0
#    $(".alert").alert "close"

  app.updateSearchFields = (options) ->
    if options.hub.length > 0
      $("#hub").val options.hub[0]
      $("#location").val options.hub[1]

  app.loginInterrupt = (elem, callback) ->
    $("#loginModal").modal()
    $("#loginModal .login_form").data("remote", true).attr("format", "json").on "ajax:success", (e, data, status, xhr) ->
      if data.success
        $("#loginModal").modal "toggle"
        app.redrawLoggedInNav
          callback: callback
          elem: elem

        true
      else
        app.createModalAlert "We could not sign you in with the supplied name and password", "error", "#loginModal"
        false

    false

  app.configureHubFilter = (groupname_elem, select_width) ->
    location_input = $(groupname_elem).data("locationInput")
    location_id = $(groupname_elem).data("locationId")
    selected_hub = $(groupname_elem).data("selectedHub")
    $(groupname_elem).select2
      minimumInputLength: 1
      placeholder: "Enter a group"
      width: select_width
      allowClear: true
      ajax:
        url: "/hubs"
        dataType: "json"
        data: (term, page) ->
          hub_filter: term
          location_id_filter: $(location_input).val()

        results: (data, page) ->
          results: data

      formatResult: (item) ->
        item.full_hub

      formatSelection: (item) ->
        $(location_input).val item.formatted_location
        $(location_id).val item.location_id #.closest('form').submit();
        $(groupname_elem).val item.group_name
        item.group_name

      formatNoMatches: (term) ->

        # see https://github.com/ivaynberg/select2/issues/448
        # this onclick inline handler is not my idea of a good solution but it works for now.
        "No matches. <a id=\"navCreateHub\" onclick=\"app.navCreateHub()\" href=\"#\">Create one</a>"


      # TODO: This doesn't work, need help
      # See example at http://ivaynberg.github.com/select2/#events
      # createSearchChoice: function(term, data) {
      #   if ($(data).filter(function() {
      #     return this.group_name.localeCompare(term) === 0;
      #   }).length === 0) {
      #     return {hub_filter: term, location_id_filter: ''};
      #   }
      initSelection: (element, callback) ->
        callback selected_hub

    if groupname_elem is "#hub_filter"
      $(groupname_elem).select2 "focus"
      $(groupname_elem).on "change", (e) ->

        # user clicked the 'x' to clear the groupname selection
        # so clear location as well
        $("#location_id_filter, #location_filter").val ""  if @value is ""

    $(location_input).on "hover focus", (e) ->
      if @value isnt ""
        $(".clear-location").removeClass("hide").on "click", (e) ->
          $(location_input).val ""
          $(this).addClass "hide"



  app.setPageHeight = ->
    vp = new Viewport()
    vph = vp.height
    if $("section.clear").length > 0 or $("section.searched").length > 0
      $("#mainContent").height vph - 142
    else
      $("#mainContent").height vph - 140  if vph > $("#mainContent").height()

  app.fillNavSearch = ->
    $("#hub, #location").each ->
      self = $(this)
      self.val self.data("value")  unless self.data("value") is ""


  app.pageEffects = ->
    $("#user_email").focus()  if $(".content_page #new_user").length > 0
    app.setPageHeight()
    app.fillNavSearch()

  app.redrawLoggedInNav = (options) ->
    options = options or {}
    newNav = ""
    $.get "/user_nav", (data) ->
      if data.success
        $("header.navbar").remove()
        $("body").prepend data.content
        options.callback options.elem  if options.callback


  app.gpSearch = (elem) ->
    defaultBounds = new google.maps.LatLngBounds(new google.maps.LatLng(-33.8902, 151.1759), new google.maps.LatLng(-33.8474, 151.2631))
    options =
      bounds: defaultBounds
      types: ["(regions)"]

    autocomplete = new google.maps.places.Autocomplete(elem, options)
    google.maps.event.addListener autocomplete, "place_changed", ->
      place = autocomplete.getPlace()
      value_field = $(elem).data("valueField")
      $(value_field).val place.id
      if elem.id is "location_filter"

        # this was a navbar search, preload the hub modal location field
        # TODO figure out how to do this in app.navCreateHub() instead
        $("#hub_formatted_location").val place.formatted_address
        $("#hub_location_id").val place.id


  app.validateNavbarSearch = (e) ->
    locationLength = $("#location_filter").val().length > 0
    group_length = $("#hub_filter").val().length > 0
    if not locationLength and not group_length
      app.errorMessage "Please enter a group name and location to find."
      return false
    if locationLength
      if $("#hub_filter").val().length is 0
        app.errorMessage "Please enter a group name, search only by location is not supported at this time"
        $("#hub_filter").focus()
        false

  app.reloadHome = ->
    if $("#homepage").length is 0
      e.preventDefault()
    else
      window.location.replace "/"

  app.navLogin = (e) ->
    app.loginInterrupt this, app.reloadHome

  app.navReg = (e) ->

    # If user was on login modal and clicked Join...
    if $("#loginModal").hasClass("in")
      $("#loginModal").modal "hide"
      $(".login_form").off "ajax:success"
    $("#registrationModal").modal()
    $("#registrationModal .login_form").data("remote", true).attr("format", "json").on "ajax:success", (e, data, status, xhr) ->
      if status is "success"
        window.location.assign "/"
      else
        app.errorMessage "We could not register you"
        false

    false

  app.navCreateHub = (e) ->

    # e.preventDefault();
    searchGroup = $(".select2-input").val()
    $("#s2id_hub_filter").select2 "close"
    $("#hubModal").find("#hub_group_name").val searchGroup
    $("#hubModal").modal()


  #  TODO: Move this logic to an Angular controller at some point?
  #  app.saveNewHub = function(e) {
  #    e.preventDefault();
  #    $.post('/hubs.json', $('#new_hub').serialize(), function(data) {
  #      if (data.id === 'undefined') {
  #        alert('Could not create this group: ' + data.errors);
  #      } else {
  #        $('#hubModal').modal('toggle');
  #        app.successMessage('Your group was created');
  #      }
  #    })
  #  }
  $ ->
    $("[rel=tooltip]").tooltip()
    $("[rel=popover]").popover trigger: "hover"
    $("body").on "click", app.closeAlert
    $("#navLogin").on "click", app.navLogin
    $("#navJoin, #loginReg").on "click", app.navReg
    $(".shares").on "click", "a", (e) ->
      e.preventDefault()
      window.open $(this).attr("href")

    $("select").select2 width: "200px"
    $("#hubModalSave").on "click", app.saveNewHub
    $("#navbarSearch").on "submit", app.validateNavbarSearch
    $("#confirmationModalNo").on "click", (e) ->
      e.preventDefault()
      $(this).parents(".modal").modal "hide"

    $(".btn-disabled").on "click", (e) ->
      false

    $(".related_supporting").last().css "border-bottom", "none"
    app.pageEffects()
    app.configureHubFilter "#hub_filter", "220px"
    app.configureHubFilter "#proposal_hub_group_name", "220px"

    # $(document).on('click', '#navCreateHub', app.navCreateHub);
    $(".gpSearchBox").each ->
      app.gpSearch this


    # See https://github.com/twitter/bootstrap/issues/5900#issuecomment-10398454
    # This fixes the issue with navbar dropdowns not acting on clicks
    $("a.dropdown-toggle, .dropdown-menu a").on "touchstart", (e) ->
      e.stopPropagation()


)()