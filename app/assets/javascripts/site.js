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

$(function() {
  $('[rel=tooltip]').tooltip();
  $('[rel=popover]').popover();
  $('select').select2({width: '200px'});
  $('.locationSelector select').select2({placeholder: 'Select Location', width: '200px'});
  $('.related_supporting').last().css('border-bottom', 'none');
  pageEffects();
})
