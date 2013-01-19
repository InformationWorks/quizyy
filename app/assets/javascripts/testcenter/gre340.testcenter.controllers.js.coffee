Gre340.module "TestCenter.Controllers", (Controllers, Gre340, Backbone, Marionette, $, _) ->
  #TODO Review code for efficiency
  #TODO Write Tests
  class QuestionController
    constructor: () ->
      @Views = Gre340.TestCenter.Views
      @models = Gre340.TestCenter.Data.Models
      @typesToDiplayInTwoPane = ['V-MCQ-1','V-MCQ-2','V-SIP']
      @diRegEx = /^Q-DI-/i
      @numericEqRegEx = /NE-1|NE-2/i
      @textCompRegEx = /TC-2|TC-3/i
      @sipRegEx = /SIP/i
      @quiz = null
      @quizInProgress = false
      @currentSection = null
      @currentQuestion = null
      @currentQuestionCollection=null
      @currentSectionCollection=null
      @sectionNumber=1
      @isStarted = false
      @attempt = Gre340.TestCenter.Data.currentAttempt
      @totalSeconds = null
      @connection = true
      @noInternetErrorShown = false
      @loadingView = new @Views.LoadingView()
    start:() ->
      console.log 'start question controller called'
      @attempt.fetch()
      @isStarted = true
    showLoading:() ->
      Gre340.TestCenter.Layout.layout.loading.show(@loadingView)
    hideLoading:() ->
      Gre340.TestCenter.Layout.layout.loading.close()
    checkPrerequisite:()->      
      if !@attempt.isComplete() and @checkTimeAvailable() 
        true 
      else if @attempt.isComplete()
        Gre340.Routing.showRouteWithTrigger('test_center','submit')
        false
      else if !@checkTimeAvailable()
        @startNextSection()
        false
      else
        false
    loadQuiz:()->
      @quiz = Gre340.TestCenter.Data.currentQuiz
      @quiz.url = '/api/v1/quizzes/'+@attempt.get('quiz_id')+'.json'
      @quiz.fetch
        silent:false,
        async: false
    lostConnection:()->
      @connection = false
      $('#action-bar').addClass('no-connection')
      $('#action-bar').addClass('no-bk')
      $('#no-internet-error').modal('show')
    gotConnection:()->
      @connection = true
      @noInternetErrorShown = false
      if $('#action-bar').hasClass('no-connection')
        $('#action-bar').removeClass('no-connection')
        $('#action-bar').removeClass('no-bk')
      $('#no-internet-error').modal('hide')
    submitQuiz:()->
      Gre340.vent.trigger("submit:current:attempt")
    showQuestion:(question)->
      @showLoading()
      if @checkPrerequisite()
        if !@quiz 
          @loadQuiz()
        else
          @currentQuestion = question
          Gre340.vent.trigger("update:current:attempt",@currentSection.id,@currentQuestion.id)
          @showActionBar()
          @startVisit(@currentQuestion.get('id'))
          qTypeCode = question.get('type_code')
          questionIsDI = false
          questionToDisplayInTwoPane = _.find @typesToDiplayInTwoPane, (code) ->
            if(code==qTypeCode)
              true
          #Checking Data Interpretation question location top (single pane) or side (two pane)
          location =  if @diRegEx.test(qTypeCode) and question.get('di_location')? then question.get('di_location') else 'Top'
          if questionToDisplayInTwoPane or location == 'Side'
            Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionTwoPaneView(model: question))
          else
            Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionSingleView(model: question))
        @updateTimer(@totalSeconds)
        @updateServerTimeWithInterval()
      @hideLoading()
    showQuestionById:(questionId)->
      @showLoading()
      if @checkPrerequisite()
        if !@quiz 
          @loadQuiz()
        else
          question = @currentQuestionCollection.get(questionId)
          @showQuestion(question)
    showQuestionByNumber:(sectionNumber,questionNumber)->
      console.log 'show question by number called'
      @showLoading()
      if @checkPrerequisite()
        if !@quiz 
          @loadQuiz()
        else       
          if !@currentSection.get('submitted')
            question = if questionNumber <= @currentQuestionCollection.length then @currentQuestionCollection.where(sequence_no: parseInt(questionNumber))[0] else new Gre340.TestCenter.Data.Models.Question instruction: "No Such question Exists"
            @showQuestion(question)
          else
            if @attempt.get('current_question_id')?
              @currentQuestionCollection = @currentSectionCollection.get(@attempt.get('current_section_id')).get('questions')
              Gre340.Routing.showRouteWithTrigger('test_center','section',@currentSectionCollection.get(@attempt.get('current_section_id')).get('sequence_no'),'question', @currentQuestionCollection.get(@attempt.get('current_question_id')).get('sequence_no'))
            else
              Gre340.Routing.showRouteWithTrigger('test_center','section',@currentSectionCollection.get(@attempt.get('current_section_id')).get('sequence_no'))
    showActionBar: () ->
      @section_quant = false
      if /quant/i.test(@currentSection.get('section_type_name'))
        @section_quant = true
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.QuestionActionBarView(model: @quiz, section_index: @sectionNumber, question_number:@currentQuestion.get('sequence_no'),total_questions: @currentQuestionCollection.length, section_quant: @section_quant ))
    showSectionActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.SectionActionBarView(model: @quiz, section_index: @sectionNumber))
    startSection: (section,questionNumber) ->
      #TODO show section view first and then show questions
      @showLoading()
      if @checkPrerequisite()
        if !@quiz 
          @loadQuiz()
        else
          if section.get('submitted')
            if @attempt.get('current_question_id')?
              @currentQuestionCollection = @currentSectionCollection.get(@attempt.get('current_section_id')).get('questions')
              Gre340.Routing.showRoute('test_center','section',@currentSectionCollection.get(@attempt.get('current_section_id')).get('sequence_no'),'question', @currentQuestionCollection.get(@attempt.get('current_question_id')).get('sequence_no'))
              @showQuestion(@currentQuestionCollection.get(@attempt.get('current_question_id')))
            else
              Gre340.Routing.showRoute('test_center','section',@currentSectionCollection.get(@attempt.get('current_section_id')).get('sequence_no'))
              @startSection(@currentSectionCollection.get(@attempt.get('current_section_id')),null)
          else
            @currentSection = section
            @sectionNumber = section.get('sequence_no')
            #if we have recived a questionNumber than the user should see a question else we show section start information
            if questionNumber?
              @currentQuestionCollection = section.get('questions')
              Gre340.Routing.showRoute('test_center','section',@sectionNumber,'question',questionNumber)
              @showQuestion(@currentQuestion)   
            else
              Gre340.Routing.showRoute('test_center','section',@sectionNumber)
              Gre340.vent.trigger("update:current:attempt",section.id,null)
              @updateServerTime()
              @showSectionActionBar()
              Gre340.TestCenter.Layout.layout.content.show(new @Views.SectionInfoView(model: section))
        @totalSeconds = @attempt.get('current_time') if @totalSeconds == null
        @hideLoading()
    startSectionByNumber:(sectionNumber,questionNumber) ->
      @showLoading()
      if @checkPrerequisite()
        if !@quiz 
          @loadQuiz()
        else 
          section = @currentSectionCollection.where(sequence_no: parseInt(sectionNumber))[0] 
          @startSection(section,questionNumber)

    startNextSection: ()->
      @showLoading()
      @submitSection(@currentSection)
      @resetTotalSeconds()
      if @currentSectionCollection.next(@currentSection)
        Gre340.Routing.showRouteWithTrigger('test_center','section',@currentSectionCollection.next(@currentSection).get('sequence_no'))
      else
        @submitSection(@currentSection)
        Gre340.Routing.showRouteWithTrigger('test_center','submit')
    setQuiz:(model,isSilent) ->
      @quiz.set(model, {silent: isSilent})
    setQuizInProgress: ->
      @quizInProgress = true;
    getQuizInProgress: ->
      @quizInProgress
    setCurrentQuestion:(question) ->
      @currentQuestion = question
    getCurrentQuestion:->
      @currentQuestion
    setCurrentSection:(section) ->
      @currentSection = section
    getCurrentSection:->
      @currentSection
    setCurrentSectionCollection:(collection)->
      @currentSectionCollection = collection
    getCurrentSectionCollection:()->
      @currentSectionCollection
    setCurrentQuestionCollection:(collection)->
      @currentQuestionCollection=collection
    getCurrentQuestionCollection:()->
      @currentQuestionCollection
    exitQuizCenter:()->
      Gre340.TestCenter.Layout.layout.content.show(new @Views.NoQuizInProgress())
    exitSection: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.SectionExitActionBarView(model: @quiz, section_index: @sectionNumber))
      Gre340.TestCenter.Layout.layout.content.show(new @Views.SectionExitView())
    showQuizError:()->
      Gre340.TestCenter.Layout.layout.content.show(new @Views.QuizFatalError())
    submitSection:(section)->
      clearInterval(@updateInterval) if @updateInterval?
      clearInterval(@timerInterval) if @timerInterval?
      section.set submitted: true
      if @currentSection.get('sequence_no') == @currentSectionCollection.length
        Gre340.Routing.showRouteWithTrigger('test_center','submit')
    setTimer:(time)->
      @totalSeconds = time
      @updateTimer(@totalSeconds)
      if @timerInterval
        clearInterval(@timerInterval)
      @timerInterval = window.setInterval(@tick,1000)
    updateTimer:(time)->
      @timer = $('#timer')
      seconds = time

      hours = Math.floor(seconds / 3600)
      seconds -= hours * (3600)

      minutes = Math.floor(seconds / 60)
      seconds -= minutes * (60)

      timeStr = @leadingZero(hours) + ":" + @leadingZero(minutes) + ":" + @leadingZero(seconds)
      @timer.html(timeStr)
      if @timerInterval == undefined or @timerInterval == null
        @timerInterval = window.setInterval(@tick,1000)
    leadingZero: (time) ->
      if (time < 10) then "0" + time else time
    tick:()=>
      if @totalSeconds > 0 && @connection
        @totalSeconds -= 1
        @updateTimer(@totalSeconds)
      else if !@connection
        #do nothing
      else if @totalSeconds == 0
        @submitSection(@currentSection)
        @startNextSection()
    updateServerTimeWithInterval:()=>
      if @totalSeconds?
        attempt = new Backbone.Model({'attempt_id':@attempt.get('id'), 'current_time':@totalSeconds})
        attempt.url = '/api/v1/attempts/update_time'
        attempt.save null,
          success:(model,response)=>
            @gotConnection()
          error:@handleErrors
      if @updateInterval
        clearInterval(@updateInterval)
      @updateInterval = window.setInterval(@updateServerTimeWithInterval,10000)
    updateServerTime:()=>
      if @totalSeconds?
        attempt = new Backbone.Model({'attempt_id':@attempt.get('id'), 'current_time':@totalSeconds})
        attempt.url = '/api/v1/attempts/update_time'
        attempt.save null,
          success:(model,response)=>
            @gotConnection()
          error:@handleErrors
    startVisit:(question_id)->
      visit = new Backbone.Model({'attempt_id':@attempt.get('id'), 'question_id':question_id,'time':@totalSeconds})
      visit.url = '/api/v1/visits/create'
      visit.save()
    endVisit:(question_id)->
      visit = new Backbone.Model({'attempt_id':@attempt.get('id'), 'question_id':question_id,'time':@totalSeconds})
      visit.url = '/api/v1/visits/set_end_time'
      visit.save()
    resetTotalSeconds:()->
      clearInterval(@timerInterval)
      @endVisit(@currentQuestion.get('id')) if @currentQuestion
      @totalSeconds = 1800 #30mins      
    handleErrors:(model,xhr)=>
      if xhr.status == 500
        console.log 'an error occured on the server'
      else if xhr.status == 0
        console.log 'lost internet connection'
        @lostConnection()
    checkTimeAvailable:() ->
      if @totalSeconds == 0 then false else true
    showReviewSection:()->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.ReviewActionBarView(model: @quiz, section_index: @sectionNumber))
      Gre340.TestCenter.Layout.layout.content.show(new @Views.ReviewView(section_id:@currentSection.get('id'),attempt_id:@attempt.get('id'),current_question_number: @currentQuestion.get('sequence_no')))
  #-----------------------Events Listening------------------------------

  Gre340.vent.on "show:question", ->
    controller = Controllers.questionController
    if controller.checkTimeAvailable()
      Gre340.Routing.showRouteWithTrigger('test_center','section',controller.sectionNumber,'question',controller.currentQuestion.get('sequence_no'))
    else
      Gre340.vent.trigger "show:next:section"
  Gre340.vent.on "show:next:question", ->
    controller = Controllers.questionController
    if controller.checkTimeAvailable()
      if controller.currentQuestionCollection?
        if controller.currentQuestionCollection.length-1 == controller.currentQuestionCollection.indexOf(controller.currentQuestion)
          #HACK - indexOf was returning -1 instead of 0 for the first model so we first find the model and than restore it
          controller.currentSection = controller.currentSectionCollection.get(controller.currentSection)
          Gre340.vent.trigger 'exit:section'
        else
          controller.endVisit(controller.currentQuestion.get('id'))
          controller.currentQuestion = controller.currentQuestionCollection.next(controller.currentQuestion)
          Gre340.Routing.showRouteWithTrigger('test_center','section',controller.sectionNumber,'question',controller.currentQuestionCollection.indexOf(controller.currentQuestion)+1)
    else
      Gre340.vent.trigger "show:next:section"    
  
  Gre340.vent.on "show:prev:question", ->
    controller = Controllers.questionController
    if controller.checkTimeAvailable()
      if controller.currentQuestionCollection?
        if controller.currentQuestionCollection.indexOf(controller.currentQuestion) isnt 0
          controller.endVisit(controller.currentQuestion.get('id'))
          controller.currentQuestion = controller.currentQuestionCollection.prev(controller.currentQuestion)
          Gre340.Routing.showRouteWithTrigger('test_center','section',controller.sectionNumber,'question',controller.currentQuestionCollection.indexOf(controller.currentQuestion)+1)
    else
      Gre340.vent.trigger "show:next:section"
  
  Gre340.vent.on "start:section", ->
    controller = Controllers.questionController
    if controller.checkTimeAvailable()
      controller.setTimer(controller.totalSeconds)
      Gre340.Routing.showRouteWithTrigger('test_center','section',controller.sectionNumber,'question',1)
    else
      Gre340.vent.trigger "show:next:section"
  
  Gre340.vent.on "show:next:section", ->
    controller = Controllers.questionController
    controller.startNextSection()
  
  Gre340.vent.on "quiz:changed", (quiz) ->
    qc = Controllers.questionController
    qc.quiz = quiz
    console.log('quiz changed')
    qc.setCurrentSection(quiz.getCurrentSection())
    qc.setCurrentQuestion(quiz.getCurrentQuestion())
    qc.setCurrentQuestionCollection(quiz.getCurrentQuestionCollection())
    qc.setCurrentSectionCollection(quiz.getCurrentSectionCollection())
    
    if qc.getCurrentSection()?
      if qc.getCurrentQuestion()?
        qc.startSection(Controllers.questionController.getCurrentSection(),Controllers.questionController.getCurrentQuestion().get('sequence_no'))
      else
        qc.startSection(Controllers.questionController.getCurrentSection(),null)
    else
      if quiz.get('sections').length>0
        qc.setCurrentSectionCollection(quiz.get('sections'))
        qc.startSection(Controllers.questionController.getCurrentSectionCollection().first(),null)
      else
        qc.showQuizError()
  Gre340.vent.on "show:review:section", ->
    controller = Controllers.questionController
    Gre340.Routing.showRoute('test_center','section',controller.sectionNumber,'review')
    controller.showReviewSection()    
  Gre340.vent.on 'no:internet:error:shown', ->
    controller = Controllers.questionController
    controller.noInternetErrorShown = true
  Gre340.vent.on "exit:section", ->
    controller = Controllers.questionController
    Gre340.Routing.showRoute('test_center','section',controller.sectionNumber,'exit')
    controller.exitSection()
  
  #---------------------request handlers--------------------------
  Gre340.reqres.addHandler "currentAttemptId", ()->
    Controllers.questionController.attempt.get('id')

  Controllers.addInitializer ->
    Controllers.questionController = new QuestionController()
  Controllers.addFinalizer ->
    Backbone.history.stop() if Backbone.history
    console.log 'stopped controller testcenter'