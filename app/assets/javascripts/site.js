window.app = {};

(function () {

  app.successMessage = function(msg) {
    createAlert(msg, 'success');
  }

  app.errorMessage = function(msg) {
    createAlert(msg, 'error');
  }

  app.updateSearchFields = function(options) {
    if (options.hub.length > 0) {
      $('#hub').val(options.hub[0]);
      $('#location').val(options.hub[1]);
    }
  }

  app.loginInterrupt = function(elem, callback) {
    $('#loginModal').modal();
    $('#loginModal .login_form').data('remote', true).attr('format', 'json').on('ajax:success', function(e, data, status, xhr) {
      if(data.success) {
        $('#loginModal').modal('toggle');
        redrawLoggedInNav({callback: callback, elem: elem});
        return true
      } else {
        createModalAlert('We could not sign you in with the supplied name and password', 'error', '#loginModal');
        return false;
      }
    });
    return false;
  }

  app.configureHubFilter = function(groupname_elem, select_width) {
    var location_input = $(groupname_elem).data('locationInput');
    $(groupname_elem).select2({
      minimumInputLength: 1,
      placeholder: 'Enter a group',
      width: select_width,
      allowClear: true,

      ajax: {
        url: '/hubs',
        dataType: 'json',
        data: function(term, page) {
          return { hub_filter: term, location_id_filter: $(location_input).val() }
        },
        results: function(data, page) {
          return { results: data }
        }
      },

      formatResult: function(item) {
        return item.full_hub;
      },

      formatSelection: getHubName,

      formatNoMatches: function (term) {
        return 'No matches. ' + '<a href="/hubs/new?requested_group=' + term + '">Create one</a>';
      }
    });

    if (groupname_elem === '#hub_filter') {
      $(groupname_elem).select2('focus');
      $(groupname_elem).on('change', function(e) {
        // user clicked the 'x' to clear the groupname selection
        // so clear location as well
        if (this.value === '') {
          $('#location_id_filter, #location_filter').val('');
        }
      });
    }

    $(location_input).on('hover focus', function(e) {
      if (this.value !== '') {
        $('.clear-location').removeClass('hide').on('click', function(e) {
          $(location_input).val('');
          $(this).addClass('hide');
        });
      }
    });
    
  }

  // --

  var createAlert = function (msg, style) {
    $('#main').find('.content .row').first().prepend('<div class="alert alert-' + style + '"><a href="#" class="close" data-dismiss="alert">&times;</a>' + msg + '</div>');
  }

  var createModalAlert = function (msg, style, modalElem) {
    $(modalElem).find('.modal-body div').first().prepend('<div class="alert alert-' + style + '"><a href="#" class="close" data-dismiss="alert">&times;</a>' + msg + '</div>');
  }

  var setPageHeight = function() {
    var vp = new Viewport(), vph = vp.height;
    if ($('section.clear').length > 0 || $('section.searched').length > 0) {
      $('section.span11').height(vph - 122);
    } else {
      if(vph > $('#mainContent').height()) {
        $('#mainContent').height(vph - 120);
      }
    }
  }

  var fillNavSearch = function() {
    $('#hub, #location').each(function() {
      var self = $(this);
      if (self.data('value') != '') {
        self.val(self.data('value'));
      }
    });
  }

  var pageEffects = function() {
    if ($('body').height() > 1200) {
      $('body').addClass('long');
    }
    if ($('.content_page #new_user').length > 0) {
      $('#user_email').focus();
    }
    setPageHeight();
    fillNavSearch();
  }

  var redrawLoggedInNav = function(options) {
    options = options || {}
    var newNav = '';
    $.get('/user_nav', function(data) {
      if (data.success) {
        $('header.navbar').remove();
        $('body').prepend(data.content);
        if (options.callback) {
          options.callback(options.elem);
        }
      }
    });
  }

  var gpSearch = function (elem) {
    var defaultBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(-33.8902, 151.1759),
      new google.maps.LatLng(-33.8474, 151.2631)
    );

    var options = {
      bounds: defaultBounds,
      types: ['(regions)']
    };

    var autocomplete = new google.maps.places.Autocomplete(elem, options);

    google.maps.event.addListener(autocomplete, 'place_changed', function() {
      var place = autocomplete.getPlace(),
          value_field = $(elem).data('value_field');
      $(value_field).val(place.id);
    });
  }

  // helper for repetitive hub_filter select2 options
  var getHubName = function(item) {
    $('#location_filter').val(item.formatted_location);
    $('#location_id_filter').val(item.location_id)//.closest('form').submit();

    $('#proposal_hub_location_id').val(item.location_id);
    $('#proposal_hub_formatted_location').val(item.formatted_location);
    return item.group_name;
  }

  var validateNavbarSearch = function(e) {
    var locationLength = $('#location_filter').val().length > 0;
    if (locationLength) {
      if ($('#hub_filter').val().length === 0) {
        app.errorMessage('Please enter a group name, search only by location is not supported at this time');
        $('#hub_filter').focus();
        return false;
      }
    }
  }

  var reloadHome = function() {
    if ($('#homepage').length === 0) {
      e.preventDefault();
    } else {
      window.location.replace('/');
    }
  }

  var navLogin = function(e) {
    app.loginInterrupt(this, reloadHome);
  }

  var navReg = function(e) {
    // If user was on login modal and clicked Join...
    if ($('#loginModal').hasClass('in')) {
      $('#loginModal').modal('hide');
      $('.login_form').off('ajax:success');
    }
    $('#registrationModal').modal();
    $('#registrationModal .login_form').data('remote', true).attr('format', 'json').on('ajax:success', function(e, data, status, xhr) {
      if(status === 'success') {
        window.location.assign('/');
      } else {
        app.errorMessage('We could not register you');
        return false;
      }
    });
    return false;
  }

  $(function() {
    $('[rel=tooltip]').tooltip();
    $('[rel=popover]').popover();
    $('#navLogin').on('click', navLogin);
    $('#navJoin, #loginReg').on('click', navReg);
    $('select').select2({width: '200px'});
    app.configureHubFilter('#hub_filter', '220px');
    app.configureHubFilter('#proposal_hub_group_name', '220px');
    $('#navbarSearch').on('submit', validateNavbarSearch);

    $('.related_supporting').last().css('border-bottom', 'none');
    pageEffects();

    $('.gpSearchBox').each(function() {
      gpSearch(this);
    });

    // See https://github.com/twitter/bootstrap/issues/5900#issuecomment-10398454
    // This fixes the issue with navbar dropdowns not acting on clicks
    $('a.dropdown-toggle, .dropdown-menu a').on('touchstart', function(e) {
      e.stopPropagation();
    });
  });

})();
