(function () {

  /*
   * Model
   */

  var Proposal = App.Model.Proposal = App.Model.extend({
  });

  /*
   * Collection
   */

  var Proposals = App.Collection.Proposals = App.Collection.extend({
    url: '/proposals.json',
    model: Proposal,

    comparator: function(proposal) {
      return proposal.get('statement');
    }
  });

  /*
   * Proposals Index View
   */

  var ProposalsIndex = App.View.ProposalsIndex = App.View.extend({
    template: 'proposals/index',

    render: function() {
      this.$el.html(this.processTemplate({ proposals: this.collection.toArrayOfAttributes() }));
      $('#mainContent').append(this.$el);
    }
  });

  /*
   * Improve Proposal View
   */

  var ImproveProposal = App.View.ImproveProposal = App.View.extend({
  });

  /*
   * Support Proposal View
   */

  var SupportProposal = App.View.SupportProposal = App.View.extend({
  });

})();
