window.Spokenvote = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},

  initialize: function () {
    new Spokenvote.Routers.Proposals();
    Backbone.history.start({ pushState: true });
  },

  setPageHeight: function () {
    var vp = new Viewport(), vph = vp.height;
    if ($('section.clear').length > 0 || $('section.searched').length > 0) {
      $('#mainContent').height(vph - 142);
    } else {
      if (vph > $('#mainContent').height()) {
        $('#mainContent').height(vph - 140);
      }
    }
  }
};

$(document).ready(function () {
  Spokenvote.setPageHeight();
  return Spokenvote.initialize();
});
