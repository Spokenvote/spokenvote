describe "Prerender Test", ->

  it 'window.prerenderReady should be false', ->
    expect window.prerenderReady
      .toBe false