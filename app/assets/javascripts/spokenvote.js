$.extend(app, {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},

  initialize: function () {
    new app.Routers.Proposals();
    Backbone.history.start({ pushState: true });
  }
});


$(document).ready(function () {
  app.setPageHeight();
  app.initialize();
});
