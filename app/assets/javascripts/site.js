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

var pageEffects = function() {
  if ($('body').height() > 1200) {
    $('body').addClass('long');
  }
  setPageHeight();
}

var updateSearchFields = function(options) {
  if (options.hub.length > 0) {
    $('#hub').val(options.hub[0]);
    $('#location').val(options.hub[1]);
  }
}

var redrawLoggedInNav = function() {
  var newNav = '';
  $.get('/user_nav', function(data) {
    if (data.success) {
      $('header.navbar').remove();
      $('body').prepend(data.content);
    }
  })
}

var loginInterrupt = function(callback, elem) {
  $('#loginModal').modal();
  $('.login_form').data('remote', true).attr('format', 'json').on('ajax:success', function(e, data, status, xhr) {
    if(data.success) {
      // process success case
      $('#loginModal').modal('toggle');
      redrawLoggedInNav(data.user);
      if (callback) {
        callback(elem);
      }
      return true
    } else {
      // let the user know they failed authentication
      errorMessage('We could not sign you in with the supplied name and password');
      return false;
    }
  });
  return false;
}

$(function() {
  $('[rel=tooltip]').tooltip();
  $('[rel=popover]').popover();
  $('select').select2({width: '200px'});
  $('.locationSelector select').select2({placeholder: 'Select Location', width: '200px'});
  $('.related_supporting').last().css('border-bottom', 'none');
  pageEffects();
})
