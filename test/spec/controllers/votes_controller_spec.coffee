
describe 'Proposal Support Controller Tests', ->
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'

  describe 'SupportController should perform a Controller tasks', ->
    $rootScope = undefined
    $controller = undefined
    $httpBackend = undefined
    $location = undefined
    $scope = undefined
    ctrl = undefined
    relatedSupport =
      id: 122
      proposal:
        id: 8
        statement: 'Related proposal statement'
        votes_attributes:
          comment: 'Why you should vote for this related proposal'

    new_vote =
      comment: 'Why you should vote for this proposal'

    clicked_proposal =
      id: '17'
      proposal:
        statement: 'My proposal statement'

    saved_vote =
      id: 87
      proposal_id: 6
      comment: "Want to see that response one more time ..."
      user_id: 44
      created_at: "2013-07-15T03:41:12.747Z"
      updated_at: "2015-02-19T12:46:13.196Z"
      ip_address: "127.0.0.1"
      username: "Kim Miller"

    failed_vote =
      comment:  ["can't be blank"]

    beforeEach inject ( _$rootScope_, _$controller_, _$httpBackend_, _SessionSettings_, _$location_ ) ->
      $rootScope = _$rootScope_
      $controller = _$controller_
      $httpBackend = _$httpBackend_
      $location = _$location_
      $rootScope.sessionSettings = _SessionSettings_
      $rootScope.alertService =
        clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
        setInfo: jasmine.createSpy 'alertService:setInfo'
        setCtlResult: jasmine.createSpy 'alertService:setCtlResult'
        setSuccess: jasmine.createSpy 'alertService:setSuccess'
        setJson: jasmine.createSpy 'alertService:setJson'
      $scope = $rootScope.$new()
      ctrl = $controller 'SupportController',
        $scope: $scope
      $scope.sessionSettings.newSupport.vote = new_vote
      $scope.sessionSettings.newSupport.target = clicked_proposal

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()


    describe 'should initialize properly with NO related support', ->

      it 'should initialize scope items', ->

        expect $scope.sessionSettings.newSupport.related
          .toEqual null
        expect $scope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $scope.alertService.setCtlResult.calls.count()
          .toEqual 0

      it 'should initialize properly WITH related support', ->

        $rootScope.alertService.clearAlerts = jasmine.createSpy 'alertService:clearAlerts'
        $rootScope.alertService.setInfo = jasmine.createSpy 'alertService:setInfo'
        $scope = $rootScope.$new()
        $scope.sessionSettings.newSupport.related = relatedSupport
        ctrl = $controller 'SupportController',
          $scope: $scope

        expect $scope.sessionSettings.newSupport.related
          .toEqual relatedSupport
        expect $scope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $scope.alertService.setInfo.calls.count()
          .toEqual 1


    describe 'saveSupport method', ->

      it 'should properly initialize before saving Support', ->

        $rootScope.alertService =
          clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
          setCtlResult: jasmine.createSpy 'alertService:setCtlResult'
          setSuccess: jasmine.createSpy 'alertService:setSuccess'

        spyOn $scope, 'saveSupport'
          .and.callThrough()

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond saved_vote, 200

        $httpBackend.flush()

        expect $scope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $scope.alertService.setCtlResult.calls.count()
          .toEqual 0
        expect $scope.sessionSettings.newSupport.vote.proposal_id
          .toEqual $scope.sessionSettings.newSupport.target.id
        expect $scope.saveSupport
          .toHaveBeenCalled()

      it 'should issue POST while saving Support', ->

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond saved_vote, 200

        $httpBackend.flush()

      it 'should broadcast "event:votesChanged" while saving Support', ->

        spyOn($rootScope, '$broadcast')
          .and.callThrough()

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond saved_vote, 201

        $httpBackend.flush()

        expect $rootScope.$broadcast
          .toHaveBeenCalledWith 'event:votesChanged'

      it 'should send alert "Vote Saved" while saving Support', ->

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond saved_vote, 201

        $httpBackend.flush()

        expect $rootScope.alertService.setSuccess
          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
        expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
          .toContain 'Your vote was created with the comment:'

      it 'should properly find vote comment in response while saving Support', ->

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond saved_vote, 201

        $httpBackend.flush()

        expect $rootScope.alertService.setSuccess
          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
        expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
          .toContain 'Want to see that response one more time ...'

      it 'should turn off comment box while saving Support', ->

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond saved_vote, 201

        $httpBackend.flush()

        expect $scope.sessionSettings.actions.newProposal.comment
          .toEqual null

      it 'should navigate to new proposal while saving Support', ->

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond saved_vote, 201

        $httpBackend.flush()

        expect $location.url()
          .toEqual '/proposals/6'

      it 'should send alert "Sorry, your vote was not saved" if saving Support fails', ->

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond 422, failed_vote

        $httpBackend.flush()

        expect $rootScope.alertService.setCtlResult
          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
          .toContain 'Sorry, your vote to support this proposal was not counted.'

      it 'should return JSON data in alert "Sorry, your vote was not saved" if saving Support fails', ->

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond 422, failed_vote

        $httpBackend.flush()

        expect $rootScope.alertService.setJson
          .toHaveBeenCalledWith jasmine.any(Object)
        expect $rootScope.alertService.setJson.calls.mostRecent().args[0]
          .toEqual comment: [ "can't be blank" ]

    describe 'saveSupport method', ->


#  describe "NewProposalCtrl", ->
#    mockBackend = undefined
#    location = undefined
#    beforeEach inject(($rootScope, $controller, _$httpBackend_, $location, Proposal, SessionSettings) ->
#      mockBackend = _$httpBackend_
#      location = $location
#      $scope = $rootScope.$new()
#      $scope.sessionSettings = SessionSettings
#      $scope.sessionSettings =
#        hub_attributes:
#          id: 1
#          group_name: 'Hacker Dojo'
#      $scope.newProposal =
#        statement: "Jasmine test proposal"
#        comment: "Jasmine test proposal comment"
#      $dialog =
#        close: -> ''
#      ctrl = $controller("NewProposalCtrl",
#        $scope: $scope
#        parentScope: $scope
#        dialog: $dialog
#        $location: $location
#        proposal: new Proposal(
#          proposal:
#            id: 1
#            statement: "Jasmine test proposal"
#            votes_attributes:
#              comment: "Jasmine test proposal comment"
#            hub_id: 1
#            hub_attributes:
#              group_name: 'Hacker Dojo'
#        )
#      )
#    )
#    it "should save the proposal", ->
#      mockBackend.expectPOST("/proposals",
#        proposal:
#          statement: "Jasmine test proposal"
#          votes_attributes:
#            comment: "Jasmine test proposal comment"
#          hub_id: 1
#          hub_attributes:
#            id: 1
#            group_name: 'Hacker Dojo'
#      ).respond id: 2
#      location.path "test"
#      $scope.saveNewProposal()
#      expect(location.path()).toEqual "/test"
#      mockBackend.flush()
#      expect(location.path()).toEqual "/proposals/2"


#  describe "DeleteProposalCtrl", ->
#    mockBackend = undefined
#    location = undefined
#    beforeEach inject(($rootScope, $controller, _$httpBackend_, $location) ->
#      mockBackend = _$httpBackend_
#      location = $location
#      $scope = $rootScope.$new()
#      prntScope =
#        clicked_proposal:
#          id: 1
#          votes: ['']
#      $dialog =
#        close: -> ''
#      ctrl = $controller("DeleteProposalCtrl",
#        $scope: $scope
#        parentScope: prntScope
#        dialog: $dialog
#        $location: $location
#      )
#    )
#    it "should delete the proposal", ->
#      mockBackend.expectDELETE("/proposals/1?votes=",
#      ).respond []
#      location.path "test"
#      $scope.deleteProposal()
#      expect(location.path()).toEqual "/test"
#      mockBackend.flush()
#      expect(location.path()).toEqual "/proposals"
