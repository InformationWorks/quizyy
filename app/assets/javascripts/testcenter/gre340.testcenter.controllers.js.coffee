Gre340.module "TestCenter.Controllers", (Controllers, Gre340, Backbone, Marionette, $, _) ->
  #TODO Review code for efficiency
  #TODO Write Tests
  class QuestionController
    constructor: () ->
      @Views = Gre340.TestCenter.Views
      @models = Gre340.TestCenter.Data.Models
      @typesToDiplayInTwoPane = ['V-MCQ-1','V-MCQ-2','V-SIP','Q-DI-MCQ-1','Q-DI-MCQ-2','Q-DI-NE-1','Q-DI-NE-2']
      @quiz = new @models.Quiz()
      @quizInProgress = false
      @currentSection = null
      @currentQuestion = null
      @currentQuestionCollection=null
      @currentSectionCollection=null
      @sectionNumber=1
      @isStarted = false
    start:() ->
      #@questionCollection.fetch()
      console.log 'i am called'
      @quiz.fetch(async: false)
    showQuestion:(question) ->
      @showActionBar()
      @currentQuestion = question
      qTypeCode = question.get('type').code
      questionToDisplayInTwoPane = _.find @typesToDiplayInTwoPane, (code) ->
        if(code==qTypeCode)
          return true
      #Checking Data Interpretation question location top (single pane) or side (two pane)
      diLocation =  if question.get('di_location')? then question.get('di_location') else 'Top'
      if !questionToDisplayInTwoPane and diLocation == 'Top'
        Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionSingleView(model: question))
      else
        Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionTwoPaneView(model: question))
    showQuestionById:(questionId)->
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
    showQuestionByNumber:(sectionNumber,questionNumber)->
      if !@quiz.get('sections')?
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
        @currenQuestionCollection = @currentSection.get('questions')
      question = if questionNumber <= @currentQuestionCollection.length then @currentQuestionCollection.at(questionNumber-1) else new Gre340.TestCenter.Data.Models.Question instruction: "No Such question Exists"
      @showQuestion(question)
    showActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.QuestionActionBarView(model: @quiz, section_index: @sectionNumber))
    showSectionActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.SectionActionBarView(model: @quiz, section_index: @sectionNumber))
    startSection: (section,questionNumber) ->
      #TODO show section view first and then show questions
      console.log 'start section called'
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
      @startSection(@currentSectionCollection.next(@currentSection),null)
    startPrevSection: ()->
      @startSection(@currentSectionCollection.prev(@currentSection),@currentQuestionCollection.length)
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
      if controller.currentQuestionCollection.indexOf(controller.currentQuestion) == 0
        controller.startPrevSection() if controller.currentSectionCollection.indexOf(controller.currentSection) != 0
      else
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
      Controllers.questionController.setCurrentSectionCollection(quiz.get('sections'))
      Controllers.questionController.startSection(Controllers.questionController.getCurrentSectionCollection().first(),null)

  Controllers.addInitializer ->
    Controllers.questionController = new QuestionController()

  Controllers.addFinalizer ->
      console.log 'stopped controller testcenter'