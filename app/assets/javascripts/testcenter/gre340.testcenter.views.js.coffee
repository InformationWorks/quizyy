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

  Views.SectionInfoView = Marionette.ItemView.extend
    template: 'question/section'
    tagName: "div"
    initialize: (options) ->
    onRender:() ->
      @$('#section-info').append(@model.get('display_text'))
  Views.QuestionActionBarView = Marionette.ItemView.extend
    template: 'actionbar'
    model: 'Gre340.TestCenter.Data.Models.Quiz'
    initialize: (options) ->
      @section_index = options.section_index
      @question_number = options.question_number
      @total_questions = options.total_questions
    templateHelpers: ->
      section_index: @section_index
      question_number: @question_number
      total_questions: @total_questions
    events:
      'click #btn-next': 'showNextQuestion'
      'click #btn-prev': 'showPrevQuestion'
    showNextQuestion: (event) ->
      event.preventDefault()
      Gre340.vent.trigger 'show:next:question'
    showPrevQuestion: (event) ->
      event.preventDefault()
      Gre340.vent.trigger 'show:prev:question'

  Views.SectionActionBarView = Marionette.ItemView.extend
    template: 'section-actionbar'
    model:'Gre340.TestCenter.Data.Models.Quiz'
    initialize: (options) ->
      @section_index = options.section_index
    templateHelpers: ->
      section_index: @section_index
    events:
      'click #btn-continue': 'startSection'
    startSection:(event) ->
      event.preventDefault()
      Gre340.vent.trigger 'start:section'

  Views.NoQuizInProgress = Marionette.ItemView.extend
    template: 'no-attempt-error'

  Views.QuizFatalError = Marionette.ItemView.extend
    template: 'quiz-error'