Gre340.module "TestCenter.Views", (Views, Gre340, Backbone, Marionette, $, _) ->
  Views.toggleMarkQuestion = (marked)->
    $('#marked').val(marked)
    if marked
      $('#btn-mark').children(":first").html('<span class="win-commandimage win-commandring">&#xe070;</span>')
    else
      $('#btn-mark').children(":first").html('<span class="win-commandimage win-commandring">&#xe071;</span>')
  Views.OptionsView = Marionette.ItemView.extend
    initialize:(options)->
      question_type = @model.get('type_code')
      @singleRight = false
      if /QC|TC-1|[A-Z]*-MCQ-1/i.test(question_type)
        @oneRightAnswer = true
      @attempt_details = new Backbone.Collection()
      @attempt_details.url =  '/api/v1/attempt_details'
      @attempt_details.fetch(data: $.param({ attempt_id: Gre340.request('currentAttemptId'), question_id: @model.get('id')}), async: false )
      @listenTo Gre340.vent, "mark:question:toggle", ()->
        currentState = $('#marked').val()
        if currentState == "true"
          $('#marked').val(false)
          $('#btn-mark').children(":first").html('<span class="win-commandimage win-commandring">&#xe071;</span>')
          @model.set('marked',false)
        else
          $('#marked').val(true)
          #show marked icon on button
          $('#btn-mark').children(":first").html('<span class="win-commandimage win-commandring">&#xe070;</span>')
          @model.set('marked',true)
        @saveUserResponse()   
    templateHelpers: ->
      oneRightAnswer: @oneRightAnswer
      attempt_details: @attempt_details
    events:
      'change input[type=checkbox]': 'saveUserResponse'
      'change input[type=radio]': 'saveUserResponse'
      'change select': 'saveUserResponse'
      'change input[type=text]': 'saveUserResponse'
    getTemplate:()->
      question_type = @model.get('type_code')
      @numericEqRegEx = /NE-1|NE-2/i
      @textCompRegEx = /TC-1|TC-2|TC-3/i
      @sipRegEx = /SIP/i
      @qtype = ''
      if @numericEqRegEx.test(question_type)
        $(@el).addClass('ne')
        @qtype = 'ne'
        'option/ne'
      else if @textCompRegEx.test(question_type)
        @qtype = 'tc'
        'option/tc'
      else if @sipRegEx.test(question_type)
        @qtype = 'none'
        'option/none'
      else
        @qtype = 'mcq'
        'option/mcq'
    saveUserResponse:(event)->
      if @qtype == 'ne' or @qtype == 'none'
        type = "text"  
      else
        type= "notext"
      
      if @qtype=='none'
        options = $('.sentence.selected').attr('data-index')
      else
        options = new Backbone.Model(option for option in $('#options form').serializeArray())
      Gre340.vent.trigger "save:attempt:details",type,options,@model
    onRender:()->
      marked = if @attempt_details.length>0 then @attempt_details.first().get('marked') else false
      Views.toggleMarkQuestion(marked)
      @model.set('marked',marked)
      if @qtype != 'ne'
        $('#calculator').calculator
          showOn: 'operator'
          layout: [$.calculator.CLOSE,'MRMCM+M-MS', '_7_8_9_/CA',
            '_4_5_6_*CE', '_1_2_3_-SR', '+-_0_._+_=']
          closeText: 'X'
        $('#btn-calc').click =>
          $('#calculator').calculator('show')
          $('.calculator-popup').css
            position: 'absolute'
            top: '400px'
            width: 'auto'
            left: '100px'
            display: 'block'
          $('.calculator-popup').draggable()
      else
        @$('input[type=text]').calculator
          showOn: 'operator'
          layout: [$.calculator.CLOSE,'MRMCM+M-MS', '_7_8_9_/CA',
            '_4_5_6_*CE', '_1_2_3_-SR', '+-_0_._+_=',$.calculator.USE]
          closeText: 'X'
          useText: 'Transfer Display'
        selectedInput = null
        @$('input[type=text]').focus ->
          selectedInput = @
        $('#btn-calc').click =>
          if @$('input[type=text]').length > 1 and selectedInput != null
            $(selectedInput).calculator('show')
          else if @$('input[type=text]').length > 1 and selectedInput == null
            @$('input[type=text]').first().calculator('show')
          else
            @$('input[type=text]').calculator('show')
          $('.calculator-popup').draggable()
  Views.QuestionSingleView = Marionette.Layout.extend
    template: 'question/single'
    tagName: "div"
    className: "single"
    regions:
      optionsRegion: '#options'
    initialize: (options) ->
      @removeFullHeight()
    removeFullHeight: ->
      $('body').scrollTop(0)
      $('body').removeClass('fill')
    onRender:()->
      if /<BLANK-[A-Z]*>/gi.test @$('.question').text()
        @$('.question').html(@$('.question').text().replace(/<BLANK-[A-Z]*>/gi,'<div class="blank"></div>'))
      @optionsRegion.show(new Views.OptionsView(model: @model))

  Views.QuestionTwoPaneView = Marionette.Layout.extend
    initialize:->
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
      $('body').scrollTop(0)
      $('body').addClass('fill')
    onRender:()->
      if /SIP/i.test @model.get('type_code')
        @model.set('type','sip')  
        @attempt_details = new Backbone.Collection()
        @attempt_details.url =  '/api/v1/attempt_details'
        @attempt_details.fetch(data: $.param({ attempt_id: Gre340.request('currentAttemptId'), question_id: @model.get('id')}), async: false )
        marked = if @attempt_details.length>0 then @attempt_details.first().get('marked') else false
        Views.toggleMarkQuestion(marked)
        @model.set('marked',marked)
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
      @optionsRegion.show(new Views.OptionsView(model: @model))
    saveSentenceSelection:(event)->
      @$('.sentence').removeClass('selected')
      @$(event.currentTarget).addClass('selected')
      sentence_index = event.currentTarget.attributes['data-index'].value
      Gre340.vent.trigger "save:attempt:details","text",sentence_index,@model
  Views.SectionInfoView = Marionette.ItemView.extend
    template: 'question/section'
    tagName: "div"
    initialize: (options) ->
      @removeFullHeight()
    onRender:() ->
      @$('#section-info').append(@model.get('display_text'))
    removeFullHeight: ->
      $('body').removeClass('fill') 

  Views.QuestionActionBarView = Marionette.ItemView.extend
    template: 'actionbar'
    model: 'Gre340.TestCenter.Data.Models.Quiz'
    initialize: (options) ->
      @section_index = options.section_index
      @question_number = options.question_number
      @total_questions = options.total_questions
      @showCalc = options.section_quant
    templateHelpers: ->
      section_index: @section_index
      question_number: @question_number
      total_questions: @total_questions
      showCalc: @showCalc
    events:
      'click #btn-next': 'showNextQuestion'
      'click #btn-prev': 'showPrevQuestion'
      'click #btn-exit-section': 'exitSection'
      'click #btn-review': 'showReview'
      'click #btn-mark': 'toggleMarkQuestion'
      'click #btn-quit':'quitQuiz'
      'click #btn-hide-time': 'toogleTimer'
      'click #show-alert-quit-quiz': 'removeBackgroundFromActionBar'
      'click .close-alert-quit-quiz': 'addBackgroundToActionBar'
    showNextQuestion: (event) ->
      event.preventDefault()
      Gre340.vent.trigger 'show:next:question'
    showPrevQuestion: (event) ->
      event.preventDefault()
      Gre340.vent.trigger 'show:prev:question'
    showReview:(event)->
      event.preventDefault()
      Gre340.vent.trigger 'show:review:section'
    exitSection: (event) ->
      Gre340.vent.trigger 'exit:section'
    quitQuiz:(event) ->
      event.preventDefault()
      console.log 'comes here'
      window.location.href = '/homes/index';
    removeBackgroundFromActionBar: (event)->
      $('.action-bar-wrapper').addClass('no-bk')
    addBackgroundToActionBar:(event) ->
      event.preventDefault()
      $('.action-bar-wrapper').removeClass('no-bk')
    toggleMarkQuestion:(event)->
      Gre340.vent.trigger 'mark:question:toggle'
    toogleTimer:(event)->
      timer = @$('#timer')
      timer.toggle()
      if timer.css('display') == 'block'
        @$(event.currentTarget).text('Hide Time')
      else
        @$(event.currentTarget).text('Show Time')
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

  Views.SectionExitActionBarView = Marionette.ItemView.extend
    template: 'section-exit-actionbar'
    model:'Gre340.TestCenter.Data.Models.Quiz'
    initialize: (options) ->
      @section_index = options.section_index
    templateHelpers: ->
      section_index: @section_index
    events:
      'click #btn-continue': 'showNextSection'
      'click #btn-return': 'showQuestion'
      'click #btn-review': 'showReview'
    showNextSection:(event) ->
      event.preventDefault()
      Gre340.vent.trigger 'show:next:section'
    showQuestion: (event) ->
      event.preventDefault()
      Gre340.vent.trigger 'show:question'
    showReview:(event)->
      event.preventDefault()
      Gre340.vent.trigger 'show:review:section'

  Views.NoQuizInProgress = Marionette.ItemView.extend
    template: 'no-attempt-error'

  Views.QuizFatalError = Marionette.ItemView.extend
    template: 'quiz-error'

  Views.SectionExitView = Marionette.ItemView.extend
    template: 'section-exit'

  Views.LoadingView = Marionette.ItemView.extend
    template: 'loading'
    
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
  Views.ReviewActionBarView = Marionette.ItemView.extend
    template: 'review-actionbar'
    model:'Gre340.TestCenter.Data.Models.Quiz'
    initialize: (options) ->
      @section_index = options.section_index
    templateHelpers: ->
      section_index: @section_index
    events:
      'click #btn-return': 'returnSection'
      'click #btn-go-to-q': 'goToQuestion'
    returnSection:(event) ->
      event.preventDefault()
      question_number =  $('.current')[0].attributes['data-value'].value
      Gre340.Routing.showRouteWithTrigger('test_center','section',@section_index,'question',question_number)
    goToQuestion:(event)->
      event.preventDefault()
      if $('.ui-selected').length > 0
        question_number =  $('.ui-selected')[0].attributes['data-value'].value
        Gre340.Routing.showRouteWithTrigger('test_center','section',@section_index,'question',question_number)

  Views.ReviewQuestionRow = Marionette.ItemView.extend
    template:'question/review-question-row'
    tagName: 'tr'
    initialize:(options)->
      @current_question_number = options.current_question_number
      $(@el).attr 'data-value', @model.get('sequence_no')
      if @current_question_number==@model.get("sequence_no") 
        $(@el).addClass('current')
  Views.ReviewView = Marionette.CompositeView.extend
    initialize:(options)->
      @removeFullHeight()
      @section_id = options.section_id
      @attempt_id = options.attempt_id
      @current_question_number = options.current_question_number
      @collection = new Backbone.Collection()
      @collection.comparator = (item) -> item.get('sequence_no')
      @collection.url = '/api/v1/attempt_details/questions_status?section_id='+@section_id+'&attempt_id='+@attempt_id
      @collection.fetch(async:false)
    template:"question/review"
    itemView:Views.ReviewQuestionRow
    itemViewOptions:(model) ->
        {current_question_number: @current_question_number} 
    appendHtml:(collectionView, itemView, index) ->
      if index+1 > itemView.model.collection.length/2
        collectionView.$("#right tbody").append(itemView.el)
      else
        collectionView.$("#left tbody").append(itemView.el)
    onRender:()->
      @$('.selectable').selectable
        filter:'tr'
        cancel: '.cancel'
    removeFullHeight: ->
      $('body').scrollTop(0)
      $('body').removeClass('fill') 
