
describe 'Proposal Votes Controllers Tests', ->
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'

  describe 'Votes Controllers should perform a Controller tasks', ->
    $rootScope = undefined
    $controller = undefined
    $httpBackend = undefined
    $location = undefined
    $scope = undefined
    ctrl = undefined
    Vote = undefined
    Proposal = undefined
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
      statement: 'My proposal statement'

    improved_proposal =
      proposal:
        parent_id: clicked_proposal.id
        statement: 'Improved proposal statement'
        votes_attributes:
          comment: 'I like wording it this way better'

    saved_vote =
      id: 87
      proposal_id: 6
      comment: "Want to see that response one more time ..."
      user_id: 44
      created_at: "2013-07-15T03:41:12.747Z"
      updated_at: "2015-02-19T12:46:13.196Z"
      ip_address: "127.0.0.1"
      username: "Kim Miller"

    saved_proposal =
      id: 99
      statement: 'Improved proposal statement'
      user_id: 44
      created_at: "2013-07-15T03:41:12.747Z"
      updated_at: "2015-02-19T12:46:13.196Z"
      ip_address: "127.0.0.1"
      username: "Kim Miller"
      votes_attributes:
        comment: 'Why you should vote for this related proposal'

    failed_vote =
      comment:  ["can't be blank"]

    testTrash = 'Trash should should get killed'

    beforeEach inject ( _$rootScope_, _$controller_, _$httpBackend_, _SessionSettings_, _$location_ ) ->
      $rootScope = _$rootScope_
#      $controller = _$controller_
      $httpBackend = _$httpBackend_
      $rootScope.sessionSettings = _SessionSettings_
      $location = _$location_
      $rootScope.alertService =
        clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
        setInfo: jasmine.createSpy 'alertService:setInfo'
        setCtlResult: jasmine.createSpy 'alertService:setCtlResult'
        setSuccess: jasmine.createSpy 'alertService:setSuccess'
        setJson: jasmine.createSpy 'alertService:setJson'
      $scope = $rootScope.$new()

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    describe 'SupportController should perform SUPPORT Controller tasks', ->

      beforeEach inject ( _$controller_, _Vote_ ) ->
        $controller = _$controller_
        Vote = _Vote_
        ctrl = $controller 'SupportController',
          $scope: $scope

        $scope.sessionSettings.vote =
          target: clicked_proposal

      it 'should initialize properly', ->

        expect $scope.sessionSettings.vote.related_existing
          .toEqual undefined
        expect $scope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $scope.alertService.setInfo.calls.count()
          .toEqual 0
        expect $scope.vote
          .toEqual {}

      it 'should initialize properly reset the vote object', ->

        $scope.vote = new_vote
        ctrl = $controller 'SupportController',
          $scope: $scope

        expect $scope.vote
          .toEqual {}

      it 'should properly initialize during saving Support', ->

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

      it 'should properly find correct proposal to which to attach vote', ->

        spyOn Vote, 'save'
          .and.callThrough()

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond saved_vote, 201

        $httpBackend.flush()

        expect Vote.save.calls.count()
          .toEqual 1
        expect Vote.save.calls.mostRecent().args[0].proposal_id
          .toEqual '17'

      it 'should turn off comment box while saving Support', ->

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond saved_vote, 201

        $httpBackend.flush()

        expect $scope.sessionSettings.vote
          .toEqual {}

      it 'should navigate to new proposal while saving Support', ->

        $scope.saveSupport()

        $httpBackend
          .expectPOST '/votes'
          .respond saved_vote, 201

        $httpBackend.flush()

        expect $location.url()
          .toEqual '/proposals/6#prop6'

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



#    describe 'ImproveController should perform IMPROVE Controller tasks', ->
#
#      beforeEach inject ( _$controller_, _Proposal_ ) ->
#        $controller = _$controller_
#        Proposal = _Proposal_
#        $scope.sessionSettings.vote =
#          parent: clicked_proposal
#        ctrl = $controller 'ImproveController',
#          $scope: $scope
#
#      it 'should initialize properly reset the improvedProposal object', ->
#
#        $scope.improvedProposal = testTrash
#
#        ctrl = $controller 'ImproveController',
#          $scope: $scope
#
#        expect $scope.improvedProposal.statement
#          .toEqual clicked_proposal.statement
#
#      it 'should properly initialize and call save on improvedProposal', ->
#
#        $rootScope.alertService =
#          clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
#          setCtlResult: jasmine.createSpy 'alertService:setCtlResult'
#          setSuccess: jasmine.createSpy 'alertService:setSuccess'
#
#        spyOn $scope, 'saveImprovement'
#          .and.callThrough()
#
#        $scope.saveImprovement()
#
#        $httpBackend
#          .expectPOST '/proposals'
#          .respond saved_vote, 200
#
#        $httpBackend.flush()
#
#        expect $scope.alertService.clearAlerts.calls.count()
#          .toEqual 1
#        expect $scope.alertService.setCtlResult.calls.count()
#          .toEqual 0
#        expect $scope.saveImprovement
#          .toHaveBeenCalled()
#
#      it 'should issue POST while saving Support', ->
#
#        $scope.saveImprovement()
#
#        $httpBackend
#          .expectPOST '/proposals'
#          .respond saved_vote, 200
#
#        $httpBackend.flush()
#
#      it 'should send alert "Proposal Saved" while saving Support', ->
#
#        $scope.saveImprovement()
#
#        $httpBackend
#          .expectPOST '/proposals'
#          .respond saved_proposal, 201
#
#        $httpBackend.flush()
#
#        expect $rootScope.alertService.setSuccess
#          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
#        expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
#          .toContain 'Your improved proposal stating: "' + saved_proposal.statement + '" was created.'
#
#      it 'should properly find Improved Proposal text in response after saving Support', ->
#
##        $scope.improvedProposal.statement = 'Some crazy new Proposal statement'
#
#        $scope.saveImprovement()
#
#        $httpBackend
#          .expectPOST '/proposals'
#          .respond saved_proposal, 201
#
#        $httpBackend.flush()
#
#        expect $rootScope.alertService.setSuccess
#          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
#        expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
#          .toContain 'Your improved proposal stating: "' + saved_proposal.statement + '" was created.'
#
#      it 'should properly find correct Proposal Statement and Vote Comment while saving', ->
#
#        spyOn Proposal, 'save'
#          .and.callThrough()
#
#        $scope.improvedProposal.statement = improved_proposal.proposal.statement
#        $scope.improvedProposal.comment = improved_proposal.proposal.votes_attributes.comment
#
#        $scope.saveImprovement()
#
#        $httpBackend
#          .expectPOST '/proposals'
#          .respond saved_proposal, 201
#
#        $httpBackend.flush()
#
#        expect Proposal.save.calls.count()
#          .toEqual 1
#        expect Proposal.save.calls.mostRecent().args[0]
#          .toEqual improved_proposal
#
#      it 'should turn off Improve Proposal box while saving Support', ->
#
#        $scope.saveImprovement()
#
#        $httpBackend
#          .expectPOST '/proposals'
#          .respond saved_vote, 201
#
#        $httpBackend.flush()
#
#        expect $scope.sessionSettings.vote
#          .toEqual {}
#
#      it 'should navigate to new Improved Proposal after saving Support', ->
#
#        $scope.saveImprovement()
#
#        $httpBackend
#          .expectPOST '/proposals'
#          .respond saved_vote, 201
#
#        $httpBackend.flush()
#
#        expect $location.url()
#          .toEqual '/proposals/' + saved_vote.id
#
#      it 'should send alert "Sorry, your Proposal was not saved" if saving Support fails', ->
#
#        $scope.saveImprovement()
#
#        $httpBackend
#          .expectPOST '/proposals'
#          .respond 422, failed_vote
#
#        $httpBackend.flush()
#
#        expect $rootScope.alertService.setCtlResult
#          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
#        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
#          .toContain 'Sorry, your improved proposal was not saved.'
#
#      it 'should return JSON data in alert "Sorry, your proposal was not saved" if saving Proposal fails', ->
#
#        $scope.saveImprovement()
#
#        $httpBackend
#          .expectPOST '/proposals'
#          .respond 422, failed_vote
#
#        $httpBackend.flush()
#
#        expect $rootScope.alertService.setJson
#          .toHaveBeenCalledWith jasmine.any(Object)
#        expect $rootScope.alertService.setJson.calls.mostRecent().args[0]
#          .toEqual comment: [ "can't be blank" ]



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
