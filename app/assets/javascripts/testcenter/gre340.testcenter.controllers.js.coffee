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
      @quiz = new @models.Quiz()
      @quizInProgress = false
      @currentSection = null
      @currentQuestion = null
      @currentQuestionCollection=null
      @currentSectionCollection=null
      @sectionNumber=1
      @isStarted = false
      @attempt = Gre340.TestCenter.Data.currentAttempt
      @totalSeconds = null
    start:() ->
    #have moved quiz fetch to attempt:reset event
    #so we only load quiz once we find the current attempt
    #TODO we should show a loading image when starting the controller
      console.log 'start question controller called'
      @attempt.fetch()
      @isStarted = true
    #sorce w2school
    getCookie: (c_name) ->
      i = undefined
      x = undefined
      y = undefined
      ARRcookies = document.cookie.split(";")
      i = 0
      while i < ARRcookies.length
        x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="))
        y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1)
        x = x.replace(/^\s+|\s+$/g, "")
        return unescape(y)  if x is c_name
        i++
    updateCurrentAttempt: (currentSectionId,currentQuestionId) ->
      @attempt.set({'current_section_id': currentSectionId,'current_question_id': currentQuestionId},{silent: true})
      @attempt.save()
    showQuestion:(question) ->
      @currentQuestion = question
      @updateCurrentAttempt(@currentSection.id,@currentQuestion.id)
      @showActionBar()
      qTypeCode = question.get('type_code')
      questionIsDI = false
      questionToDisplayInTwoPane = _.find @typesToDiplayInTwoPane, (code) ->
        if(code==qTypeCode)
          true
      #Checking Data Interpretation question location top (single pane) or side (two pane)
      location =  if @diRegEx.test(qTypeCode) and question.get('di_location')? then question.get('di_location') else 'Top'
      console.log(qTypeCode)
      console.log(question.get('di_location'))
      if questionToDisplayInTwoPane or location == 'Side'
        Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionTwoPaneView(model: question))
      else
        Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionSingleView(model: question))
      @setTimer(@totalSeconds)
      @updateServerTime()
    showQuestionById:(questionId)->
      console.log 'show question by Id called'
      if @quiz?
        if !@quiz.get('sections')?
          @attempt.fetch
            silent:true,
            async: false
          console.log 'attempt fetch complete'
          @quiz.url = '/api/v1/quizzes/'+@attempt.get('quiz_id')+'.json'
          @quiz.fetch
            silent:true,
            async: false,
            success:()=>
              @currentSectionCollection = @quiz.get('sections') if !@currentSectionCollection?
                if !@currentSection?
                  _.each @currentSectionCollection.models, (section)=>
                    if section.get('questions').get(questionId)?
                      @currentSection=section
                @currentQuestionCollection = @currentSection.get('questions') if !@currentQuestionCollection?
                @sectionNumber = @currentSectionCollection.indexOf(@currentSection)+1
          question = @currentQuestionCollection.get(questionId)

        @showQuestion(question)
      else
        @exitQuizCenter()

    showQuestionByNumber:(sectionNumber,questionNumber)->
      console.log 'show question by number called'
      if @quiz?
        if !@quiz.get('sections')?
          @attempt.fetch(silent:true,async: false)
          @totalSeconds = @attempt.get('current_time')
          @quiz.url = '/api/v1/quizzes/'+@attempt.get('quiz_id')+'.json'
          @quiz.fetch
            silent:true,
            async: false,
            success:()=>
              @currentSectionCollection = @quiz.get('sections') if !@currentSectionCollection?
              @currentSection = @currentSectionCollection.where(sequence_no: parseInt(sectionNumber))[0]
              @currentQuestionCollection = @currentSection.get('questions') if !@currentQuestionCollection?
              @sectionNumber = sectionNumber
        if @sectionNumber != sectionNumber
          @sectionNumber = sectionNumber
          @currentSection = @currentSectionCollection.where(sequence_no: parseInt(sectionNumber))[0]
          @currentQuestionCollection = @currentSection.get('questions')
        if !@currentSection.get('submitted')
          question = if questionNumber <= @currentQuestionCollection.length then @currentQuestionCollection.where(sequence_no: parseInt(questionNumber))[0] else new Gre340.TestCenter.Data.Models.Question instruction: "No Such question Exists"
          @showQuestion(question)
        else
          if @attempt.get('current_question_id')?
            @currentQuestionCollection = @currentSectionCollection.get(@attempt.get('current_section_id')).get('questions')
            Gre340.Routing.showRouteWithTrigger('test_center','section',@currentSectionCollection.get(@attempt.get('current_section_id')).get('sequence_no'),'question', @currentQuestionCollection.get(@attempt.get('current_question_id')).get('sequence_no'))
          else
            Gre340.Routing.showRouteWithTrigger('test_center','section',@currentSectionCollection.get(@attempt.get('current_section_id')).get('sequence_no'))
      else
        @exitQuizCenter()
    showActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.QuestionActionBarView(model: @quiz, section_index: @sectionNumber, question_number:@currentQuestion.get('sequence_no'),total_questions: @currentQuestionCollection.length))
    showSectionActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.SectionActionBarView(model: @quiz, section_index: @sectionNumber))
    startSection: (section,questionNumber) ->
      #TODO show section view first and then show questions
      if section.get('submitted')
        if @attempt.get('current_question_id')?
          @currentQuestionCollection = @currentSectionCollection.get(@attempt.get('current_section_id')).get('questions')
          Gre340.Routing.showRouteWithTrigger('test_center','section',@currentSectionCollection.get(@attempt.get('current_section_id')).get('sequence_no'),'question', @currentQuestionCollection.get(@attempt.get('current_question_id')).get('sequence_no'))
        else
          Gre340.Routing.showRouteWithTrigger('test_center','section',@currentSectionCollection.get(@attempt.get('current_section_id')).get('sequence_no'))
      else
        @currentSection = section
        @sectionNumber = section.get('sequence_no')
        #if we have recived a questionNumber than the user should see a question else we show section start information
        if questionNumber?
          @currentQuestionCollection = section.get('questions')
          Gre340.Routing.showRouteWithTrigger('test_center','section',@sectionNumber,'question',questionNumber)
        else
          @updateCurrentAttempt(section.id,null)
          @showSectionActionBar()
          Gre340.TestCenter.Layout.layout.content.show(new @Views.SectionInfoView(model: section))
      @totalSeconds = 1800 if @totalSeconds == null #30 mins
    startSectionByNumber:(sectionNumber,questionNumber) ->
      console.log('start section by number')
      if !@quiz.get('sections')?
        @attempt.fetch(silent:true,async: false)
        @quiz.url = '/api/v1/quizzes/'+ @attempt.get('quiz_id')+'.json'
        @quiz.fetch
          silent:true,
          async:false,
          success:()=>
            @currentSectionCollection = @quiz.get('sections') if !@currentSectionCollection?
            @currentSection = @currentSectionCollection.where(sequence_no: parseInt(sectionNumber))[0]
            @currentQuestionCollection = @currentSection.get('questions') if !@currentQuestionCollection?
            @sectionNumber = sectionNumber
      else
        @currentSectionCollection = @quiz.get('sections') if !@currentSectionCollection?
        @currentSection = @currentSectionCollection.where(sequence_no: parseInt(sectionNumber))[0]
        @currentQuestionCollection = @currentSection.get('questions') if !@currentQuestionCollection?
        @sectionNumber = sectionNumber
      @startSection(@currentSection,questionNumber)
    startNextSection: ()->
      @submitSection(@currentSection)
      Gre340.Routing.showRouteWithTrigger('test_center','section',@currentSectionCollection.next(@currentSection).get('sequence_no'))
#TODO: Remove this function later if not needed
#    startPrevSection: ()->
#      @startSection(@currentSectionCollection.prev(@currentSection),@currentQuestionCollection.length)
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
    exitQuizCenter:()->
      Gre340.TestCenter.Layout.layout.content.show(new @Views.NoQuizInProgress())
    exitSection: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.SectionExitActionBarView(model: @quiz, section_index: @sectionNumber))
      Gre340.TestCenter.Layout.layout.content.show(new @Views.SectionExitView())
    showQuizError:()->
      Gre340.TestCenter.Layout.layout.content.show(new @Views.QuizFatalError())
    submitSection:(section)->
      clearInterval(@updateInterval) if @updateInterval?
      section.set submitted: true
    setTimer:(time)->
      @totalSeconds = time
      @timer = $('#timer')
      @updateTimer()
      if @timerInterval
        clearInterval(@timerInterval)
      @timerInterval = window.setInterval(@tick,1000)
    updateTimer:()->
      @timer.html(@totalSeconds)
    tick:()=>
      if @totalSeconds > 0
        @totalSeconds -= 1
        @updateTimer()
      else
        clearInterval(@timerInterval)
    updateServerTime:()=>
      if @totalSeconds?
        attempt = new Backbone.Model({'attempt_id':@attempt.get('id'), 'current_time':@totalSeconds})
        attempt.url = '/api/v1/attempts/update_time'
        attempt.save()
      if @updateInterval
        clearInterval(@updateInterval)
      @updateInterval = window.setInterval(@updateServerTime,10000)   
  #Events Listening
  Gre340.vent.on "show:question", ->
    controller = Controllers.questionController
    console.log controller.sectionNumber
    console.log controller.currentQuestion.get('sequence_no')
    Gre340.Routing.showRouteWithTrigger('test_center','section',controller.sectionNumber,'question',controller.currentQuestion.get('sequence_no'))
  Gre340.vent.on "show:next:question", ->
    controller = Controllers.questionController
    if controller.currentQuestionCollection?
      if controller.currentQuestionCollection.length-1 == controller.currentQuestionCollection.indexOf(controller.currentQuestion)
        #HACK - indexOf was returning -1 instead of 0 for the first model so we first find the model and than restore it
        controller.currentSection = controller.currentSectionCollection.get(controller.currentSection)
        Gre340.vent.trigger 'exit:section' if controller.currentSectionCollection.indexOf(controller.currentSection) != controller.currentSectionCollection.length-1
      else
        controller.currentQuestion = controller.currentQuestionCollection.next(controller.currentQuestion)
        console.log(controller.currentQuestion.get('id'))
        Gre340.Routing.showRouteWithTrigger('test_center','section',controller.sectionNumber,'question',controller.currentQuestionCollection.indexOf(controller.currentQuestion)+1)

  Gre340.vent.on "show:prev:question", ->
    controller = Controllers.questionController
    if controller.currentQuestionCollection?
      if controller.currentQuestionCollection.indexOf(controller.currentQuestion) isnt 0
        controller.currentQuestion = controller.currentQuestionCollection.prev(controller.currentQuestion)
        Gre340.Routing.showRouteWithTrigger('test_center','section',controller.sectionNumber,'question',controller.currentQuestionCollection.indexOf(controller.currentQuestion)+1)

  Gre340.vent.on "start:section", ->
    controller = Controllers.questionController
    Gre340.Routing.showRouteWithTrigger('test_center','section',controller.sectionNumber,'question',1)
  Gre340.vent.on "show:next:section", ->
    controller = Controllers.questionController
    Gre340.Routing.showRouteWithTrigger('test_center','section',parseInt(controller.sectionNumber)+1,null)
  Gre340.vent.on "quiz:changed", (quiz) ->
    console.log('quiz changed')
    qc = Controllers.questionController
    qc.setCurrentSectionCollection(quiz.get('sections')) unless qc.getCurrentSection()?
    qc.setCurrentSection(qc.getCurrentSectionCollection().get(qc.attempt.get('current_section_id'))) if qc.attempt.get('current_section_id')?
    qc.setCurrentQuestion(qc.getCurrentSection().get('questions').get(qc.attempt.get('current_question_id'))) if qc.getCurrentSection()? and qc.attempt.get('current_question_id')?

    if Controllers.questionController.getCurrentSection()?
      if Controllers.questionController.getCurrentQuestion()?
        Controllers.questionController.startSection(Controllers.questionController.getCurrentSection(),Controllers.questionController.getCurrentQuestion().get('sequence_no'))
      else
        Controllers.questionController.startSection(Controllers.questionController.getCurrentSection(),null)
    else
      if quiz.get('sections').length>0
        Controllers.questionController.setCurrentSectionCollection(quiz.get('sections'))
        Controllers.questionController.startSection(Controllers.questionController.getCurrentSectionCollection().first(),null)
      else
        Controllers.questionController.showQuizError()

  Gre340.vent.on "new:attempt", (attempt) ->
    console.log 'attempt changed so load quiz'
    @quiz = Controllers.questionController.quiz
    if attempt?
      if @quiz?
        @quiz.url = '/api/v1/quizzes/'+attempt.get('quiz_id')+'.json'
        @quiz.fetch(async: true)
      else #if somehow quiz is null then exit the test center
        Controllers.questionController.exitQuizCenter()
    else
      Controllers.questionController.exitQuizCenter()
  Gre340.vent.on "exit:section", ->
    controller = Controllers.questionController
    Gre340.Routing.showRoute('test_center','section',controller.sectionNumber,'exit')
    controller.exitSection()
  #request handlers
  Gre340.reqres.addHandler "currentAttemptId", ()->
    Controllers.questionController.attempt.get('id')

  Controllers.addInitializer ->
    Controllers.questionController = new QuestionController()

  Controllers.addFinalizer ->
    Backbone.history.stop() if Backbone.history
    console.log 'stopped controller testcenter'