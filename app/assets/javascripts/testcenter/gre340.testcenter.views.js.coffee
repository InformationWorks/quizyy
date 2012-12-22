Gre340.module "TestCenter.Views", (Views, Gre340, Backbone, Marionette, $, _) ->
  Views.QuestionSingleView = Marionette.ItemView.extend
    template: 'question/single'
    tagName: "div"
    className: "single"

  Views.QuestionTwoPaneView = Marionette.ItemView.extend
    template: 'question/twopane'
    tagName: "div"
    className: "row"
    initialize: (options) ->
      @makeFullHeight()
    makeFullHeight: ->
      $('body').addClass('fill')

  Views.QuestionActionBarView = Marionette.ItemView.extend
    template: 'actionbar'