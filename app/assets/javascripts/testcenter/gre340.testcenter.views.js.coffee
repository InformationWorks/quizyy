Gre340.module "TestCenter.Views", (Views, Gre340, Backbone, Marionette, $, _) ->
  Views.OptionsView = Marionette.ItemView.extend
    initialize:(options)->
      question_type = @model.get('type_code')
      @template = @getOptionsTemplate(question_type)
    getOptionsTemplate:(question_type)->
      @numericEqRegEx = /NE-1|NE-2/i
      @textCompRegEx = /TC-2|TC-3/i
      @sipRegEx = /SIP/i
      if @numericEqRegEx.test(question_type)
        'option/ne'
      else if @textCompRegEx.test(question_type)
        'option/tc'
      else if @sipRegEx.test(question_type)
        'option/none'
      else
        'option/mcq'
  Views.QuestionSingleView = Marionette.Layout.extend
    template: 'question/single'
    tagName: "div"
    className: "single"
    regions:
      optionsRegion: '#options'
    initialize: (options) ->

    onRender:()->
      @optionsRegion.show(new Views.OptionsView(model: @model))
      @$('.question').html(@$('.question').text().replace(/<BLANK-[A-Z]*>/gi,'<div class="blank"></div>'))

  Views.QuestionTwoPaneView = Marionette.Layout.extend
    template: 'question/twopane'
    tagName: "div"
    className: "row"
    regions:
      optionsRegion: '#options'
    initialize: (options) ->
      @makeFullHeight()
    makeFullHeight: ->
      $('body').addClass('fill')
    onRender:()->
      @optionsRegion.show(new Views.OptionsView(model: @model))

  Views.SectionInfoView = Marionette.ItemView.extend
    template: 'question/section'
    tagName: "div"
    initialize: (options) ->
    onRender:() ->
      if @model.submitted? and not @model.submitted
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