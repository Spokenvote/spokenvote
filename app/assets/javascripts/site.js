var hider = function(e) {
  e.preventDefault();
  var target = $(this).data('dismiss');
  $(target).addClass('hide');
}

$(function() {
  $('[rel=tooltip]').tooltip();
  $('#closeHero').click(hider);
  $('select').select2();
  $('.related_supporting').last().css('border-bottom', 'none')
  if ($('section.span11').length > 0) {
    vp = new Viewport();
    $('section.span11').height(vp.height);
  }
})