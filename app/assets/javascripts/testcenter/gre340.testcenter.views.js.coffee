Gre340.module "TestCenter.Views", (Views, Gre340, Backbone, Marionette, $, _) ->
  Views.QuestionSingleView = Marionette.ItemView.extend
    template: 'question/single'
    tagName: "div"
    className: "single"
    initialize: (options) ->


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
    model: 'Gre340.TestCenter.Data.Models.Quiz'
    initialize: (options) ->
      @section_index = options.section_index
    templateHelpers: ->
      section_index: @section_index
    events:
      'click #btn-next': 'showNextQuestion'
      'click #btn-prev': 'showPrevQuestion'
    showNextQuestion: (event) ->
      event.preventDefault()
      Gre340.vent.trigger 'show:next:question'
    showPrevQuestion: (event) ->
      event.preventDefault()
      Gre340.vent.trigger 'show:prev:question'