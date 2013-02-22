var App = {};

App.Model = Backbone.Model.extend({});

App.Collection = Backbone.Collection.extend({
  toArrayOfAttributes: function() {
    return this.toArray().map(function (model) {
      return model.attributes;
    });
  }
});

App.View = Backbone.View.extend({
  processTemplate: function(data) {
    if (_.isUndefined(this.compileTemplate)) {
      var _this = this;
      var html = $.ajax({
        async: false,
        url: '/templates/' + this.template + '.html',
        success: function (html) {
          _this.compileTemplate = Handlebars.compile(html);
        }
      });
    }
    return this.compileTemplate(data);
  }
});

$(function () {
  var router = new App.Router();
  Backbone.history.start({ pushState: true });
});
