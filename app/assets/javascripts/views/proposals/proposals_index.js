Spokenvote.Views.ProposalsIndex = Backbone.View.extend({

  template: JST['proposals/index'],

  render: function () {
    var renderedHtml = this.template({proposals: this.collection.toJSON()});
    this.$el.html(renderedHtml);
    $('#mainContent').append(this.$el);
    this
  }
});
