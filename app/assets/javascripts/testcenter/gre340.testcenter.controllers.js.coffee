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
      @connection = true
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
    lostConnection:()->
      @connection = false
    gotConnection:()->
      @connection = true
    updateCurrentAttempt: (currentSectionId,currentQuestionId) ->
      @attempt.set({'current_section_id': currentSectionId,'current_question_id': currentQuestionId},{silent: true})
      @attempt.save()
    submitQuiz:()->
      @attempt.set({'completed': true},{silent: true})
      @attempt.save()
    showQuestion:(question) -> 
      if !@attempt.get('completed')
        @currentQuestion = question
        if @checkTimeAvailable()
          @updateCurrentAttempt(@currentSection.id,@currentQuestion.id)
          @showActionBar()
          @startVisit(@currentQuestion.get('id'))
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
          @updateTimer(@totalSeconds)
          @updateServerTimeWithInterval()
        else
          @startNextSection()
      else
         Gre340.Routing.showRouteWithTrigger('test_center','submit')
    showQuestionById:(questionId)->
      if !@attempt.get('completed')
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
          if @checkTimeAvailable()
            @showQuestion(question)
          else
            @startNextSection()
        else
          @exitQuizCenter()
      else
        Gre340.Routing.showRouteWithTrigger('test_center','submit')
    showQuestionByNumber:(sectionNumber,questionNumber)->
      console.log 'show question by number called'
      if !@attempt.get('completed')
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
      else
        Gre340.Routing.showRouteWithTrigger('test_center','submit')
    showActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.QuestionActionBarView(model: @quiz, section_index: @sectionNumber, question_number:@currentQuestion.get('sequence_no'),total_questions: @currentQuestionCollection.length))
    showSectionActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.SectionActionBarView(model: @quiz, section_index: @sectionNumber))
    startSection: (section,questionNumber) ->
      #TODO show section view first and then show questions
      if !@attempt.get('completed') 
        if @checkTimeAvailable()
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
              @updateServerTime()
              @showSectionActionBar()
              Gre340.TestCenter.Layout.layout.content.show(new @Views.SectionInfoView(model: section))
          @totalSeconds = @attempt.get('current_time') if @totalSeconds == null
        else
          @currentSection = section
          @startNextSection()
      else
        Gre340.Routing.showRouteWithTrigger('test_center','submit')
    startSectionByNumber:(sectionNumber,questionNumber) ->
      console.log('start section by number')
      if !@attempt.get('completed')
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
        
        if @checkTimeAvailable()
          @startSection(@currentSection,questionNumber)
        else
          @startNextSection()
      else
        Gre340.Routing.showRouteWithTrigger('test_center','submit')
    startNextSection: ()->
      @submitSection(@currentSection)
      @resetTotalSeconds()
      if @currentSectionCollection.next(@currentSection)
        Gre340.Routing.showRouteWithTrigger('test_center','section',@currentSectionCollection.next(@currentSection).get('sequence_no'))
      else
        @submitSection(@currentSection)
        Gre340.Routing.showRouteWithTrigger('test_center','submit')
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
      clearInterval(@timerInterval) if @timerInterval?
      section.set submitted: true
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
      
    handleErrors:(model,xhr)->
      if xhr.status == 500
        console.log 'an error occured on the server'
      else if xhr.status == 0
        console.log 'lost internet connection'
        @lostConnection()
    checkTimeAvailable:() ->
      if @totalSeconds == 0 then false else true
  #Events Listening
  Gre340.vent.on "show:question", ->
    controller = Controllers.questionController
    if controller.checkTimeAvailable()
      console.log controller.sectionNumber
      console.log controller.currentQuestion.get('sequence_no')
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
          Gre340.vent.trigger 'exit:section' if controller.currentSectionCollection.indexOf(controller.currentSection) != controller.currentSectionCollection.length-1
        else
          controller.endVisit(controller.currentQuestion.get('id'))
          controller.currentQuestion = controller.currentQuestionCollection.next(controller.currentQuestion)
          console.log(controller.currentQuestion.get('id'))
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