describe "Controllers Test", ->
  beforeEach module 'spokenvote'

  describe "Initial Validation Test", ->
    it "should match", ->
      expect("string").toMatch new RegExp("^string$")


