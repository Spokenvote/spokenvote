
describe 'Proposal Improve Controller Tests', ->
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'

  describe 'ImproveController should perform a Controller tasks', ->
    $rootScope = undefined
    $controller = undefined
    $httpBackend = undefined
    $location = undefined
    $scope = undefined
    ctrl = undefined
    improved_proposal =
      proposal:
        statement: 'New and Improved proposal statement'
        votes_attributes:
          comment: 'Why you should vote for this related proposal'

    clicked_proposal =
      id: '17'
      proposal:
        statement: 'My proposal statement'

    saved_improved_proposal =
      id: 87
      statement: 'New and Improved proposal statement'
      votes_attributes:
        comment: 'Why you should vote for this related proposal'

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
      $scope.sessionSettings.current_user_support = null
      $scope.clicked_proposal =
        statement: clicked_proposal.proposal.statement
      $scope.sessionSettings.vote.parent = clicked_proposal
#        statement: clicked_proposal.proposal.statement

      ctrl = $controller 'ImproveController',
        $scope: $scope

      $scope.improved_proposal = improved_proposal
      $scope.clicked_proposal = clicked_proposal

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()


    describe 'should initialize properly with NO related support', ->

      it 'should initialize scope items', ->

        expect $scope.current_user_support
          .toEqual undefined
        expect $scope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $scope.alertService.setInfo.calls.count()
          .toEqual 0

      it 'should initialize properly WITH related proposal', ->

        $rootScope.alertService.clearAlerts = jasmine.createSpy 'alertService:clearAlerts'
        $rootScope.alertService.setInfo = jasmine.createSpy 'alertService:setInfo'
        $scope = $rootScope.$new()
        $scope.current_user_support = 'related_proposal'
        $scope.clicked_proposal =
          statement: clicked_proposal.proposal.statement

        ctrl = $controller 'ImproveController',
          $scope: $scope

        expect $scope.current_user_support
          .toEqual 'related_proposal'
        expect $scope.alertService.clearAlerts.calls.count()
          .toEqual 1
#        expect $scope.alertService.setInfo.calls.count()
#          .toEqual 1


    describe 'saveSupport method', ->

      it 'should properly initialize before saving Improved Proposal', ->

        $rootScope.alertService =
          clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
          setCtlResult: jasmine.createSpy 'alertService:setCtlResult'
          setSuccess: jasmine.createSpy 'alertService:setSuccess'

        spyOn $scope, 'saveImprovement'
          .and.callThrough()

        $scope.saveImprovement()

        $httpBackend
          .expectPOST '/proposals'
          .respond 200, saved_improved_proposal

        $httpBackend.flush()

        expect $scope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $scope.alertService.setCtlResult.calls.count()
          .toEqual 0
#        expect $scope.sessionSettings.newSupport.vote.proposal_id
#          .toEqual $scope.sessionSettings.newSupport.target.id
        expect $scope.saveImprovement
          .toHaveBeenCalled()

      it 'should issue POST while saving Improved Proposal', ->

        $scope.saveImprovement()

        $httpBackend
          .expectPOST '/proposals'
          .respond 200, saved_improved_proposal

        $httpBackend.flush()

      it 'should send alert "Vote Saved" while saving Improved Proposal', ->

        $scope.saveImprovement()

        $httpBackend
          .expectPOST '/proposals'
          .respond saved_improved_proposal, 201

        $httpBackend.flush()

        expect $rootScope.alertService.setSuccess
          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
        expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
          .toContain 'Your improved proposal stating:'

      it 'should properly find Improved Proposal Statement in response while saving Improved Proposal', ->

        $scope.saveImprovement()

        $httpBackend
          .expectPOST '/proposals'
          .respond saved_improved_proposal, 201

        $httpBackend.flush()

        expect $rootScope.alertService.setSuccess
          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
        expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
          .toContain saved_improved_proposal.statement

      it 'should navigate to new proposal while saving Improved Proposal', ->

        $scope.saveImprovement()

        $httpBackend
          .expectPOST '/proposals'
          .respond saved_improved_proposal, 201

        $httpBackend.flush()

        expect $location.url()
          .toEqual '/proposals/87'

      it 'should send alert "Sorry, your vote was not saved" if saving Improved Proposal fails', ->

        $scope.saveImprovement()

        $httpBackend
          .expectPOST '/proposals'
          .respond 422, failed_vote

        $httpBackend.flush()

        expect $rootScope.alertService.setCtlResult
          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
          .toContain 'Sorry, your improved proposal was not saved.'

      it 'should return JSON data in alert "Sorry, your vote was not saved" if saving Improved Proposal fails', ->

        $scope.saveImprovement()

        $httpBackend
          .expectPOST '/proposals'
          .respond 422, failed_vote

        $httpBackend.flush()

        expect $rootScope.alertService.setJson
          .toHaveBeenCalledWith jasmine.any(Object)
        expect $rootScope.alertService.setJson.calls.mostRecent().args[0]
          .toEqual comment: [ "can't be blank" ]

