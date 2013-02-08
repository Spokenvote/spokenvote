window.app = {};

(function () {

  app.successMessage = function(msg) {
    app.createAlert(msg, 'success');
  }

  app.errorMessage = function(msg) {
    app.createAlert(msg, 'error');
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
        app.redrawLoggedInNav({callback: callback, elem: elem});
        return true
      } else {
        app.createModalAlert('We could not sign you in with the supplied name and password', 'error', '#loginModal');
        return false;
      }
    });
    return false;
  }

  app.configureHubFilter = function(groupname_elem, select_width) {
    var location_input = $(groupname_elem).data('locationInput'),
        location_id = $(groupname_elem).data('locationId');
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

      formatSelection: function(item) {
        $(location_input).val(item.formatted_location);
        $(location_id).val(item.location_id)//.closest('form').submit();
        $(groupname_elem).val(item.group_name);
        return item.group_name;
      },

      formatNoMatches: function(term) {
        return 'No matches. ' + '<a id="navCreateHub" href="/hubs/new?requested_group=' + term + '">Create one</a>';
      },

      // TODO: This doesn't work, need help
      // See example at http://ivaynberg.github.com/select2/#events
      // createSearchChoice: function(term, data) {
      //   if ($(data).filter(function() { 
      //     return this.group_name.localeCompare(term) === 0;
      //   }).length === 0) {
      //     return {hub_filter: term, location_id_filter: ''};
      //   }

      initSelection: function (element, callback) {
        callback(selected_hub);
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

  app.createAlert = function (msg, style) {
    $('#alertContainer').before('<div class="alert alert-' + style + '"><a href="#" class="close" data-dismiss="alert">&times;</a>' + msg + '</div>');
  }

  app.createModalAlert = function (msg, style, modalElem) {
    $(modalElem).find('.modal-body div').first().prepend('<div class="alert alert-' + style + '"><a href="#" class="close" data-dismiss="alert">&times;</a>' + msg + '</div>');
  }

  app.setPageHeight = function() {
    var vp = new Viewport(), vph = vp.height;
    if ($('section.clear').length > 0 || $('section.searched').length > 0) {
      $('#mainContent').height(vph - 142);
    } else {
      if (vph > $('#mainContent').height()) {
        $('#mainContent').height(vph - 140);
      }
    }
  }

  app.fillNavSearch = function() {
    $('#hub, #location').each(function() {
      var self = $(this);
      if (self.data('value') != '') {
        self.val(self.data('value'));
      }
    });
  }

  app.pageEffects = function() {
    if ($('.content_page #new_user').length > 0) {
      $('#user_email').focus();
    }
    app.setPageHeight();
    app.fillNavSearch();
  }

  app.redrawLoggedInNav = function(options) {
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

  app.gpSearch = function (elem) {
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
          value_field = $(elem).data('valueField');
      $(value_field).val(place.id);
      if (elem.id === 'location_filter') {
        // this was a navbar search, preload the hub modal location field
        // TODO figure out how to do this in app.navCreateHub() instead
        $('#hub_formatted_location').val(place.formatted_address);
        $('#hub_location_id').val(place.id);
      }
    });
  }

  app.validateNavbarSearch = function(e) {
    var locationLength = $('#location_filter').val().length > 0,
        group_length = $('#hub_filter').val().length > 0;

    if (!locationLength && !group_length) {
      app.errorMessage('Please enter a group name and location to find.');
      return false;
    }
    if (locationLength) {
      if ($('#hub_filter').val().length === 0) {
        app.errorMessage('Please enter a group name, search only by location is not supported at this time');
        $('#hub_filter').focus();
        return false;
      }
    }
  }

  app.reloadHome = function() {
    if ($('#homepage').length === 0) {
      e.preventDefault();
    } else {
      window.location.replace('/');
    }
  }

  app.navLogin = function(e) {
    app.loginInterrupt(this, app.reloadHome);
  }

  app.navReg = function(e) {
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
  
  app.navCreateHub = function(e) {
    e.preventDefault();
    $('#s2id_hub_filter').select2('close');
    var searchGroup = decodeURIComponent(e.target.href.split('=')[1]);

    $('#hubModal').find('#hub_group_name').val(searchGroup);
    $('#hubModal').modal();
  }
  
  app.saveNewHub = function(e) {
    e.preventDefault();
    $.post('/hubs.json', $('#new_hub').serialize(), function(data) {
      if (data.id === 'undefined') {
        alert('Could not create this hub: ' + data.errors);
      } else {
        $('#hubModal').modal('toggle');
        app.successMessage('Your hub was created');
      }
    })
  }

  $(function() {
    $('[rel=tooltip]').tooltip();
    $('[rel=popover]').popover({trigger: 'hover'});
    $('#navLogin').on('click', app.navLogin);
    $('#navJoin, #loginReg').on('click', app.navReg);
    $('.shares').on('click', 'a', function(e) {
      e.preventDefault();
      window.open($(this).attr('href'));
    })
    $('select').select2({width: '200px'});
    $('#hubModalSave').on('click', app.saveNewHub);

    app.configureHubFilter('#hub_filter', '220px');
    app.configureHubFilter('#proposal_hub_group_name', '220px');
    $('#navbarSearch').on('submit', app.validateNavbarSearch);
    $('.select2-results').on('click', '#navCreateHub', app.navCreateHub);

    $('#confirmationModalNo').on('click', function(e) {
      e.preventDefault();
      $(this).parents('.modal').modal('hide');
    });

    $('.related_supporting').last().css('border-bottom', 'none');
    app.pageEffects();

    $('.gpSearchBox').each(function() {
      app.gpSearch(this);
    });

    // See https://github.com/twitter/bootstrap/issues/5900#issuecomment-10398454
    // This fixes the issue with navbar dropdowns not acting on clicks
    $('a.dropdown-toggle, .dropdown-menu a').on('touchstart', function(e) {
      e.stopPropagation();
    });
  });
})();
