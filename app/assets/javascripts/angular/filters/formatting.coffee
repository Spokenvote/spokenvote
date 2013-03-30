angularApp.filter "capitalize", ->
  (input, scope) ->
    input.substring(0, 1).toUpperCase() + input.replace(/_/, ' ').substring(1)
