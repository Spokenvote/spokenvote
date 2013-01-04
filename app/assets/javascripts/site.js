var hider = function(e) {
  e.preventDefault();
  var target = $(this).data('dismiss');
  $(target).addClass('hide');
}

var setPageHeight = function() {
  var vp = new Viewport(), vph = vp.height;
  if ($('section.clear').length > 0 || $('section.searched').length > 0) {
    $('section.span11').height(vph);
  } else {
    if(vph > $('#mainContent').height()) {
      $('#mainContent').height(vph - 120);
    }
  }
}

$(function() {
  $('[rel=tooltip]').tooltip();
  $('[rel=popover]').popover();
  $('#closeHero').click(hider);
  $('select').select2();
  $('.related_supporting').last().css('border-bottom', 'none')
  setPageHeight();
})
