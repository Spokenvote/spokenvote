app.Routers.Proposals = Backbone.Router.extend({
  routes: {
    '': 'index'
  },

  index: function() {
    var collection = new app.Collections.Proposals();
    var view = new app.Views.ProposalsIndex({ collection: collection });
    collection.fetch();
    $('#mainContent').html(view.render().el);
  }
});
