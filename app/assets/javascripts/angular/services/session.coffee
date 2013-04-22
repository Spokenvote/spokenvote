angularApp.factory "HubFilter", ->
  group_name: "No Group has yet been specified"
#  console.log(group_name)

angularApp.factory "HubSelected", ->
  group_name: "No Group has yet been specified"
  id: "No id yet"

angularApp.factory "HubProposals", (Proposal) ->
  []

angularApp.factory "Test", ->
  data: "Objects bound across scopes"
