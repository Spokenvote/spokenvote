var hider = function(e) {
  e.preventDefault();
  var target = $(this).data('dismiss');
  $(target).addClass('hide');
}

$(function() {
  $('[rel=tooltip]').tooltip();
  $('#closeHero').click(hider);
  $('select').select2();
})