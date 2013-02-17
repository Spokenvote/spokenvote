App.Router = Backbone.Router.extend({
  routes: {
    '': 'index',
    'proposals': 'proposalsIndex'
  },

  index: function() {
    console.log('index');
  },

  proposalsIndex: function() {
    var collection = new App.Collection.Proposals();
    var view = new App.View.ProposalsIndex({ collection: collection });
    collection.on('reset', view.render.bind(view));
    collection.fetch();
  }
});
