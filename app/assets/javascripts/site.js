var createAlert = function(msg, style) {
  $('.content_page').prepend('<div class="alert alert-' + style + ' no-gutter"><a href="#" class="close" data-dismiss="alert">&times;</a>' + msg + '</div>');
}

var successMessage = function(msg) {
  createAlert(msg, 'success');
}

var errorMessage = function(msg) {
  createAlert(msg, 'error');
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

var updateSearchFields = function(options) {
  if (options.hub.length > 0) {
    $('#hub').val(options.hub[0]);
    $('#location').val(options.hub[1]);
  }
}

var redrawLoggedInNav = function(callback, elem) {
  var newNav = '';
  $.get('/user_nav', function(data) {
    if (data.success) {
      $('header.navbar').remove();
      $('body').prepend(data.content);
      if (callback) {
        callback(elem);
      }
    }
  })
}

var loginInterrupt = function(callback, elem) {
  $('#loginModal').modal();
  $('.login_form').data('remote', true).attr('format', 'json').on('ajax:success', function(e, data, status, xhr) {
    if(data.success) {
      $('#loginModal').modal('toggle');
      redrawLoggedInNav(callback, elem);
      return true
    } else {
      errorMessage('We could not sign you in with the supplied name and password');
      return false;
    }
  });
  return false;
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
    console.log(place.id);
    $(value_field).val(place.id);
  });
}

$(function() {
  $('[rel=tooltip]').tooltip();
  $('[rel=popover]').popover();
  $('select').select2({width: '200px'});
  var location_filter = $('#location_filter').val()

  $("#hub_filter").select2({
    minimumInputLength: 1,
    ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
      url: '/hubs',
      dataType: 'json',
      data: function(term, page) {
        return { hub_filter: term, google_location_id_filter: $("#google_location_id_filter").val() }
      },
      results: function(data, page) {
        return { results: data }
      }
    },
    formatResult: function (item) {
      return item.group_name
    },
    formatSelection: function (item) {
      return item.group_name
    },
    formatNoMatches: function (term) {
      return 'No matches. ' + '<a href="/hubs/new?requested_group=' + term + '">Create one</a>'
    }
  });

  $('.related_supporting').last().css('border-bottom', 'none');
  pageEffects();

  $('.gpSearchBox').each(function() {
    gpSearch(this);
  })
})
