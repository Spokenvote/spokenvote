SidebarCtrl = [ '$scope', '$routeParams', '$location', ( $scope, $routeParams, $location ) ->

  $scope.setFilter = (filterSelected) ->
    $location.path('/proposals').search('filter', filterSelected)
    $scope.sessionSettings.routeParams.filter = filterSelected

  # Accordinan Settings
  $scope.oneAtATime = true
  $scope.isopen = false

# Angular UI Sample code:
#  $scope.groups = [
#    title: "Dynamic Group Header - 1"
#    content: "Dynamic Group Body - 1"
#  ,
#    title: "Dynamic Group Header - 2"
#    content: "Dynamic Group Body - 2"
#  ]
#  $scope.items = [ "Item 1", "Item 2", "Item 3" ]
#  $scope.addItem = ->
#    newItemNo = $scope.items.length + 1
#    $scope.items.push "Item " + newItemNo

]

App.controller 'SidebarCtrl', SidebarCtrl