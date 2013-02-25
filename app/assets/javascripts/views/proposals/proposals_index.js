Spokenvote.Views.ProposalsIndex = Backbone.View.extend({

  template: JST['proposals/index'],

  render: function () {
    this.$el.html(this.template({proposals: this.collection.toJSON()}))
    $('#mainContent').append(this.$el);
    this
  }
});
