Spokenvote.Routers.Proposals = Backbone.Router.extend({
  routes: {
    '': 'index'
  },

  index: function() {
    var collection = new Spokenvote.Collections.Proposals();
    var view = new Spokenvote.Views.ProposalsIndex({ collection: collection });
    collection.on('reset', view.render.bind(view));
    collection.fetch();
  },
});
