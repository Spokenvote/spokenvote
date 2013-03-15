app.Collections.Proposals = Backbone.Collection.extend({
  url: '/proposals',
  model: app.Models.Proposal
});
