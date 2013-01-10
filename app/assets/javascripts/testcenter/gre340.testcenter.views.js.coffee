Gre340.module "TestCenter.Views", (Views, Gre340, Backbone, Marionette, $, _) ->
  Views.saveAttemptDetails=(event,model)->
    options = new Backbone.Model(option for option in $('#options form').serializeArray())
    if event.currentTarget.type == 'text'
      attempt_details = new Backbone.Model({'attempt_details':{'question_id': model.get('id'), 'user_input': options}})
    else
      attempt_details = new Backbone.Model({'attempt_details':{'question_id': model.get('id'), 'options': options}})
    attempt_details.url = '/api/v1/attempt_details'
    attempt_details.save()

  Views.OptionsView = Marionette.ItemView.extend
    initialize:(options)->
      question_type = @model.get('type_code')
      @singleRight = false
      if /QC|TC-1|[A-Z]*-MCQ-1/i.test(question_type)
        @oneRightAnswer = true
      @template = @getOptionsTemplate(question_type)
      @attempt_details = new Backbone.Collection()
      @attempt_details.url =  '/api/v1/attempt_details'
      @attempt_details.fetch(data: $.param({ attempt_id: Gre340.request('currentAttemptId'), question_id: @model.get('id')}), async: false )
    templateHelpers: ->
      oneRightAnswer: @oneRightAnswer
      attempt_details: @attempt_details
    events:
      'change input[type=checkbox]': 'saveUserResponse'
      'change input[type=radio]': 'saveUserResponse'
      'change select': 'saveUserResponse'
      'change input[type=text]': 'saveUserResponse'
    getOptionsTemplate:(question_type)->
      @numericEqRegEx = /NE-1|NE-2/i
      @textCompRegEx = /TC-1|TC-2|TC-3/i
      @sipRegEx = /SIP/i
      if @numericEqRegEx.test(question_type)
        'option/ne'
      else if @textCompRegEx.test(question_type)
        'option/tc'
      else if @sipRegEx.test(question_type)
        'option/none'
      else
        'option/mcq'
    setUserResponse: (event)->
      switch @type
        when "tc" then console.log 'tc'
        when "ne" then console.log 'ne'
    saveUserResponse:(event)->
      Views.saveAttemptDetails(event,@model)
  #TODO save user response to db

  Views.QuestionSingleView = Marionette.Layout.extend
    template: 'question/single'
    tagName: "div"
    className: "single"
    regions:
      optionsRegion: '#options'
    initialize: (options) ->
      @removeFullHeight()
    removeFullHeight: ->
      $('body').removeClass('fill')
    onRender:()->
      if /<BLANK-[A-Z]*>/gi.test @$('.question').text()
        @$('.question').html(@$('.question').text().replace(/<BLANK-[A-Z]*>/gi,'<div class="blank"></div>'))
      @optionsRegion.show(new Views.OptionsView(model: @model))

  Views.QuestionTwoPaneView = Marionette.Layout.extend
    template: 'question/twopane'
    tagName: "div"
    className: "row"
    events:
      'click .sentence': 'saveSentenceSelection'
    regions:
      optionsRegion: '#options'
    initialize: (options) ->
      @makeFullHeight()
    makeFullHeight: ->
      $('body').addClass('fill')
    onRender:()->
      if /SIP/i.test @model.get('type_code')
        @attempt_details = new Backbone.Collection()
        @attempt_details.url =  '/api/v1/attempt_details'
        @attempt_details.fetch(data: $.param({ attempt_id: Gre340.request('currentAttemptId'), question_id: @model.get('id')}), async: false )
        @selected_sentence = null
        if @attempt_details.length > 0
          @selected_sentence = @attempt_details.first().get('user_input')

        sentences = @$('.passage').text().split('.')
        passage_with_sentences = ''
        i = 0
        for sentence in sentences
          if sentence.trim() != ''
            if @selected_sentence? and parseInt(@selected_sentence)==i
              passage_with_sentences = passage_with_sentences+'<span class="sentence selected" data-index='+'"'+i+'">'+ sentence + '.</span>'
            else
              passage_with_sentences = passage_with_sentences+'<span class="sentence" data-index='+'"'+i+'">'+ sentence + '.</span>'
            i++
        @$('.passage').html(passage_with_sentences)
      else
        @optionsRegion.show(new Views.OptionsView(model: @model))
    saveSentenceSelection:(event)->
      @$('.sentence').removeClass('selected')
      @$(event.currentTarget).addClass('selected')
      sentence_index = event.currentTarget.attributes['data-index'].value
      attempt_details = new Backbone.Model({'attempt_details':{'question_id': @model.get('id'), 'user_input': sentence_index}})
      attempt_details.url = '/api/v1/attempt_details'
      attempt_details.save()

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
      'click #btn-exit-section': 'exitSection'
      'click #show-alert-exit-section': 'removeBackgroundFromActionBar'
      'click .close-alert-exit-section': 'addBackgroundToActionBar'
    showNextQuestion: (event) ->
      event.preventDefault()
      Gre340.vent.trigger 'show:next:question'
    showPrevQuestion: (event) ->
      event.preventDefault()
      Gre340.vent.trigger 'show:prev:question'
    exitSection: (event) ->
      @addBackgroundToActionBar()
      Gre340.vent.trigger 'exit:section'
    removeBackgroundFromActionBar: (event)->
      console.log 'it comes here'
      $('#action-bar').addClass('no-bk')
    addBackgroundToActionBar: ->
      $('#action-bar').removeClass('no-bk')

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

  Views.SectionSubmittedError = Marionette.ItemView.extend
    template: 'question/section-submitted-error'
    initialize: (options) ->
      @section_index = options.section_index
      @question_index = options.question_index
    events:
      'click #continue_current_attempt': 'gotoCurrentSection'
    gotoCurrentSection:(events) ->
      events.preventDefault()
      if @question_index
        Gre340.Routing.showRouteWithTrigger('test_center','section',@section_index,'question',@question_index)
      else
        Gre340.Routing.showRouteWithTrigger('test_center','section',@section_index)
