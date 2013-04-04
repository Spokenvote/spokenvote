@angularApp = angular.module("Spokenvote", ["ngResource"])

angularApp.navCreateHub = ($scope, HubFilter) ->
  $("#s2id_hub_filter").select2 "close"
#  group_name = $(".select2-input").val()
#  $("#hubModal").find("#hub_group_name").val searchGroup
  $("#hubModal").modal()

angularApp.createModalAlert = (msg, style, modalElem) ->
  $(modalElem).find(".modal-body div").first().prepend "<div class=\"alert alert-" + style + "\"><a href=\"#\" class=\"close\" data-dismiss=\"alert\">&times;</a>" + msg + "</div>"
