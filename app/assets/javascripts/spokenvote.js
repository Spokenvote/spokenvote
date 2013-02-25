window.Spokenvote = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},

  initialize: function() {
    new Spokenvote.Routers.Proposals();
    Backbone.history.start({ pushState: true });
  }
};

$(document).ready(function() {
  return Spokenvote.initialize();
});
