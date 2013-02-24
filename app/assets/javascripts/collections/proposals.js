Spokenvote.Collections.Proposals = Backbone.Collection.extend({
  url: '/proposals.json',
  model: Spokenvote.Models.Proposal
});
