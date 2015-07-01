describe 'Validation Test', ->
  beforeEach module 'spokenvote'

  describe 'Initial Validation Test', ->
    it 'should match', ->
      expect('string').toMatch new RegExp('^string$')


  describe 'plus', ->

    it 'should pass', ->
      expect true
        .toMatch true

#    it 'should work', ->
#      expect plus(1, 2)
#        .toMatch 3

#  describe 'minus', ->
#
#    it 'should work', ->
#      expect minus(1, 2)
#        .toMatch -1

