
describe 'Proposal Controller Tests', ->
  beforeEach module 'spokenvote'
#  beforeEach module 'spokenvoteMocks'

  describe 'SupportCtrl should perform a Controller tasks', ->
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
#        votes_attributes:
#          comment: 'Why you should vote for this proposal'

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
      ctrl = $controller 'SupportCtrl',
        $scope: $scope
#      spyOn($scope, '$broadcast').and.callThrough()
#      $scope.proposal.$get = jasmine.createSpy('proposal:$get')
#      promise =
#        then: jasmine.createSpy()
#      $rootScope.authService =
#        signinFb: jasmine.createSpy('authService').and.returnValue promise
#      $rootScope.votingService =
#        support: jasmine.createSpy('votingService:support')
#        improve: jasmine.createSpy('votingService:improve')
#        edit: jasmine.createSpy('votingService:edit')
#        delete: jasmine.createSpy('votingService:delete')


    describe 'should initialize properly with NO related support', ->
      it 'should initialize scope items', ->

#        $scope = $rootScope.$new()
#        ctrl = $controller 'SupportCtrl',
#          $scope: $scope

        expect $scope.sessionSettings.newSupport.related
          .toEqual null
        expect $scope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $scope.alertService.setCtlResult.calls.count()
          .toEqual 0

      it 'should initialize properly WITH related support', ->

        $rootScope.alertService =
          clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
          setCtlResult: jasmine.createSpy 'alertService:setCtlResult'
        $scope = $rootScope.$new()
        $scope.sessionSettings.newSupport.related = relatedSupport
        ctrl = $controller 'SupportCtrl',
          $scope: $scope

        expect $scope.sessionSettings.newSupport.related
          .toEqual relatedSupport
        expect $scope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $scope.alertService.setCtlResult.calls.count()
          .toEqual 1


    describe 'saveSupport method should SAVE Support', ->

      it 'should check for NEW HUB and REJECT an invalid Hub Location if saving a New Hub', ->

        $scope.sessionSettings.newSupport.vote = new_vote
        $scope.sessionSettings.newSupport.target = clicked_proposal
        $rootScope.alertService =
          clearAlerts: jasmine.createSpy 'alertService:clearAlerts'
          setCtlResult: jasmine.createSpy 'alertService:setCtlResult'

        spyOn $scope, 'saveSupport'
          .and.callThrough()
#          .and.returnValue 'Success'

        spyOn($rootScope, '$broadcast')
          .and.callThrough()


        $scope.saveSupport()
#        mockBackend.flush()


        expect $scope.alertService.clearAlerts.calls.count()
          .toEqual 1
        expect $scope.alertService.setCtlResult.calls.count()
          .toEqual 0
        expect $scope.sessionSettings.newSupport.vote.proposal_id
          .toEqual $scope.sessionSettings.newSupport.target.id
        expect $rootScope.$broadcast
          .toHaveBeenCalledWith 'event:votesChanged'
#        expect $rootScope.alertService.setCtlResult
#          .toHaveBeenCalledWith jasmine.any(String), jasmine.any(Object), jasmine.any(String)
#        expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
#          .toContain 'location appears to be invalid'
        expect $scope.saveSupport
          .toHaveBeenCalled()

  #    it 'should check for NEW HUB and ACCEPT a valid Hub Location if saving a New Hub', ->
  #      $rootScope.sessionSettings.hub_attributes =
  #        id: null
  #        formatted_location: 'Atlanta, GA'
  #      $rootScope.sessionSettings.actions.searchTerm = 'New Group Name'
  #      $rootScope.sessionSettings.openModals.newProposal = true
  #
  #      spyOn Proposal, 'save'
  #      .and.returnValue 'Success'
  #
  #      #        VotingService.saveNewProposal modalInstance
  #      VotingService.saveNewProposal()
  #
  #      expect $rootScope.alertService.clearAlerts.calls.count()
  #      .toEqual 1
  #      expect $rootScope.alertService.setCtlResult.calls.count()
  #      .toEqual 0
  #      expect $rootScope.alertService.setCtlResult.calls.count()
  #      .toEqual 0
  #      expect Proposal.save
  #      .toHaveBeenCalled()
  #
  #    it 'should check for EXISTING HUB, FIND one, and save the New Proposal', ->
  #      $rootScope.sessionSettings.hub_attributes =
  #        id: 12
  #        formatted_location: 'Atlanta, GA'
  #
  #      $rootScope.sessionSettings.newProposal =
  #        statement: 'An awesome new proposal. Vote for it!'
  #        comment: 'A million reasons to vote for this guy!'
  #
  #      $rootScope.sessionSettings.openModals.newProposal = true
  #
  #      expectedProposalSaveArgs =
  #        proposal:
  #          statement: 'An awesome new proposal. Vote for it!'
  #          votes_attributes:
  #            comment: 'A million reasons to vote for this guy!'
  #          hub_id: 12
  #          hub_attributes:
  #            id: 12
  #            formatted_location: 'Atlanta, GA'
  #
  #      spyOn Proposal, 'save'
  #      .and.returnValue 'Success'
  #
  #      VotingService.saveNewProposal modalInstance
  #
  #      expect $rootScope.alertService.clearAlerts.calls.count()
  #      .toEqual 1
  #      expect $rootScope.alertService.setCtlResult.calls.count()
  #      .toEqual 0
  #      expect Proposal.save
  #      .toHaveBeenCalled()
  #      expect Proposal.save.calls.mostRecent().args[0]
  #      .toEqual expectedProposalSaveArgs
  #
  #    it 'Proposal.save should save the New Proposal and execute correct SUCCESS callback', ->
  #      $rootScope.sessionSettings.hub_attributes =
  #        id: 12
  #      $rootScope.sessionSettings.openModals.newProposal = true
  #
  #      response =
  #        id: 2045
  #        statement: 'An awesome new proposal. Vote for it!'
  #
  #      spyOn Proposal, 'save'
  #      .and.returnValue status: 'Success'
  #
  #      VotingService.saveNewProposal()
  #      Proposal.save.calls.mostRecent().args[1] response
  #
  #      expect Proposal.save
  #      .toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function), jasmine.any(Function)
  #      expect $rootScope.alertService.setSuccess.calls.count()
  #      .toEqual 1
  #      expect $rootScope.alertService.setSuccess.calls.mostRecent().args[0]
  #      .toContain response.statement
  #      #        expect $location.url()                               # TODO bug in Angular 1.29 that will be fixed with 1.3
  #      #          .toEqual '/proposals/2045?filter=my#navigationBar'
  #      #        expect modalInstance.close
  #      #          .toHaveBeenCalledWith response
  #      expect $rootScope.sessionSettings.actions.offcanvas
  #      .toEqual false
  #
  #    it 'Proposal.save should execute correct FAILURE callback', ->
  #      $rootScope.sessionSettings.hub_attributes =
  #        id: 12
  #      $rootScope.sessionSettings.openModals.newProposal = true
  #
  #      response =
  #        data: 'There was a server error!'
  #
  #      spyOn Proposal, 'save'
  #      .and.returnValue status: 'Error'
  #
  #      VotingService.saveNewProposal modalInstance
  #      Proposal.save.calls.mostRecent().args[2] response
  #
  #      expect Proposal.save
  #      .toHaveBeenCalledWith jasmine.any(Object), jasmine.any(Function), jasmine.any(Function)
  #      expect $rootScope.alertService.setCtlResult.calls.count()
  #      .toEqual 1
  #      expect $rootScope.alertService.setCtlResult.calls.mostRecent().args[0]
  #      .toContain 'Sorry'
  #      expect $rootScope.alertService.setJson.calls.count()
  #      .toEqual 1
  #      expect $rootScope.alertService.setJson.calls.mostRecent().args[0]
  #      .toContain response.data




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
