describe "Prerender Test", ->

  describe 'prerenderReady Test', ->

    it 'window.prerenderReady should be false', ->
      expect window.prerenderReady
        .toBeUndefined()

