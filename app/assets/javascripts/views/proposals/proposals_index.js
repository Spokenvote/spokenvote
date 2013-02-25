app.Views.ProposalsIndex = Backbone.View.extend({

  template: JST['proposals/index'],

  events: {
    'click #hubSorter a': 'fetchProposalsWithParams'
  },

  initialize: function () {
    this.collection.on('reset', this.render.bind(this));
  },

  render: function () {
    this.$el.html(this.template({ proposals: this.collection.toJSON() }));
    return this;
  },

  fetchProposalsWithParams: function (event) {
    event.preventDefault();
    var target = $(event.target);
    this.collection.fetch({
      data: $.param({ filter: target.data('proposals-type') })
    });
    target.addClass('active');
  }
});
