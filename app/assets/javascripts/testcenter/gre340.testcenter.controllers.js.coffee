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
    start:() ->
      #have moved quiz fetch to attempt:reset event
      #so we only load quiz once we find the current attempt
      #TODO we should show a loading image when starting the controller
      Gre340.TestCenter.Data.currentAttempt.fetch()
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
    showQuestion:(question) ->
      @currentQuestion = question
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

    showQuestionById:(questionId)->
      if @quiz?
        if !@quiz.get('sections')?
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
      if @quiz?
        if !@quiz.get('sections')?
          attempt = Gre340.TestCenter.Data.currentAttempt
          attempt.fetch(silent:true,async: false)
          @quiz.url = '/api/v1/quizzes/'+attempt.get('quiz_id')+'.json'
          @quiz.fetch
            silent:true,
            async: false,
            success:()=>
              @currentSectionCollection = @quiz.get('sections') if !@currentSectionCollection?
              @currentSection=section = @currentSectionCollection.at(sectionNumber-1)
              @currentQuestionCollection = @currentSection.get('questions') if !@currentQuestionCollection?
              @sectionNumber = sectionNumber
        if @sectionNumber != sectionNumber
          @sectionNumber = sectionNumber
          @currentSection = @currentSectionCollection.at(sectionNumber-1)
          @currentQuestionCollection = @currentSection.get('questions')
        question = if questionNumber <= @currentQuestionCollection.length then @currentQuestionCollection.at(questionNumber-1) else new Gre340.TestCenter.Data.Models.Question instruction: "No Such question Exists"
        @showQuestion(question)
      else
        @exitQuizCenter()
    showActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.QuestionActionBarView(model: @quiz, section_index: @sectionNumber, question_number:@currentQuestion.collection.indexOf(@currentQuestion)+1,total_questions: @currentQuestionCollection.length))
    showSectionActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.SectionActionBarView(model: @quiz, section_index: @sectionNumber))
    startSection: (section,questionNumber) ->
      #TODO show section view first and then show questions
      if section.get('submitted')
        Gre340.TestCenter.Layout.layout.content.show(new @Views.SectionInfoView(model: section))
      else
        @currentSection = section
        @sectionNumber = @currentSectionCollection.indexOf(section)+1 if @currentSectionCollection
        if questionNumber?
          @currentQuestionCollection = section.get('questions')
          Gre340.Routing.showRouteWithTrigger('test_center','section',@sectionNumber,'question',questionNumber)
        else
          @showSectionActionBar()
          Gre340.TestCenter.Layout.layout.content.show(new @Views.SectionInfoView(model: section))
    startSectionByNumber:(sectionNumber,questionNumber) ->
      if !@quiz.get('sections')?
        @quiz.fetch
          silent:true,
          async: false,
          success:()=>
            @currentSectionCollection = @quiz.get('sections') if !@currentSectionCollection?
            @currentSection=section = @currentSectionCollection.at(sectionNumber-1)
            @currentQuestionCollection = @currentSection.get('questions') if !@currentQuestionCollection?
            @sectionNumber = sectionNumber
      @startSection(@currentSectionCollection.at(sectionNumber-1),questionNumber)
    startNextSection: ()->
      @submitSection(@currentSection)
      @startSection(@currentSectionCollection.next(@currentSection),null)
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
    showQuizError:()->
      Gre340.TestCenter.Layout.layout.content.show(new @Views.QuizFatalError())
    submitSection:(section)->
      #TODO post data to server mark section as complete
      section.set submitted: true
  #Events Listening
  Gre340.vent.on "show:next:question", ->
    controller = Controllers.questionController
    if controller.currentQuestionCollection?
      if controller.currentQuestionCollection.length-1 == controller.currentQuestionCollection.indexOf(controller.currentQuestion)
        #HACK - indexOf was returning -1 instead of 0 for the first model so we first find the model and than restore it
        controller.currentSection = controller.currentSectionCollection.get(controller.currentSection)
        controller.startNextSection() if controller.currentSectionCollection.indexOf(controller.currentSection) != controller.currentSectionCollection.length-1
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

  Gre340.vent.on "quiz:changed", (quiz) ->
    if Controllers.questionController.getCurrentSection()?
      if Controllers.questionController.getCurrentQuestion()?
        Controllers.questionController.showQuestionById(Controllers.questionController.getCurrentQuestion().get('id'))
      else
        Controllers.questionController.startSection(Controllers.questionController.getCurrentSection(),null)
    else
      if quiz.get('sections').length>0
        Controllers.questionController.setCurrentSectionCollection(quiz.get('sections'))
        Controllers.questionController.startSection(Controllers.questionController.getCurrentSectionCollection().first(),null)
      else
        Controllers.questionController.showQuizError()

  Gre340.vent.on "attempt:change", (attempt) ->
    console.log 'attempt changed so load quiz'
    @quiz = Controllers.questionController.quiz
    if attempt?
      if @quiz?
        console.log attempt
        @quiz.url = '/api/v1/quizzes/'+attempt.get('quiz_id')+'.json'
        @quiz.fetch(async: false)
      else #if somehow quiz is null then exit the test center
        Controllers.questionController.exitQuizCenter()
    else
      Controllers.questionController.exitQuizCenter()

  Controllers.addInitializer ->
    Controllers.questionController = new QuestionController()

  Controllers.addFinalizer ->
    Backbone.history.stop() if Backbone.history
    console.log 'stopped controller testcenter'