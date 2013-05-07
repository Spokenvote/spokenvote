VoteNewCtrl = ($scope, $location, Vote) ->
  $scope.modal = {content: 'Hello Modal', saved: false};    # part of angular-strap concept

  $scope.testScope = ->
    console.log 'proposal ' + $scope.proposal.id
    console.log 'Comment ' + $scope.newVote.comment
    console.log 'Comment ' + $scope.currentUser.id

  $scope.addVote = ->
    $scope.newVote.proposal_id = $scope.proposal.id
    $scope.newVote.user_id = $scope.currentUser.id
    $scope.addvote_result = null
    $scope.jsonErrors = null
    $scope.addvote_alert = false
    if 1 == 1
      vote = Vote.save($scope.newVote
          #TODO Error handling needs to be refactored into a Service
      ,  (response, status, headers, config) ->
        $scope.alertclass = 'ngalert alert-success'
        $scope.addvote_result = "Your " + vote.comment + " group was created."
        $scope.modal.saved = true

      ,  (response, status, headers, config) ->
        $scope.alertclass = 'ngalert alert-error'

        if(response.status == 406)
          $scope.addvote_result = "You must be logged in"
        else
          $scope.jsonErrors = response.data
      )
    else
      $scope.alertclass = 'ngalert alert-error'
      $scope.addvote_result = "Please select a Location from the provided list"

    $scope.addvote_alert = true

#    $scope.recipe = new Recipe(ingredients: [ {} ])
#    $scope.save = ->
#      $scope.recipe.$save (recipe) ->
#        $location.path "/view/" + recipe.id

  $scope.clearVote = ->
    $scope.newVote = null
    $scope.addvote_result = null
    $scope.jsonErrors = null
    $scope.addvote_alert = false
    $scope.modal.saved = false

  $scope.updateModel = ->
    $scope.newVote.formatted_location = $scope.selectedLocation.formatted_address
    $scope.newVote.location_id = $scope.selectedLocation.id

VoteNewCtrl.$inject = ['$scope', '$location', 'Vote']
angularApp.controller 'VoteNewCtrl', VoteNewCtrl