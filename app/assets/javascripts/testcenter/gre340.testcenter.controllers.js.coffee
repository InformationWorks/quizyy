Gre340.module "TestCenter.Controllers", (Controllers, Gre340, Backbone, Marionette, $, _) ->
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
      @sectionIndex= 1
      @isStarted = false
    start:() ->
      #@questionCollection.fetch()
      console.log 'i am called'
      @quiz.fetch(async: false)
    showQuestion:(question_id) ->
      @showActionBar()
      if @quiz.isNew()
        @quiz.fetch(
          silent:true,
          async: false,
          success:()=>
            @currentSectionCollection = @quiz.get('sections') if !@currentSectionCollection?
            if !@currentSection?
              _.each @currentSectionCollection.models, (section)=>
                if section.get('questions').get(question_id)?
                  @currentSection=section
            @currentQuestionCollection = @currentSection.get('questions') if !@currentQuestionCollection?
        )
      question = @currentQuestionCollection.get(question_id)
      @currentQuestion = question
      qTypeCode = question.get('type').code
      questionToDisplayInTwoPane = _.find @typesToDiplayInTwoPane, (code) ->
        if(code==qTypeCode)
          return true

      #check for Data Interpretation question location top (single pane) or side (two pane)

      diLocation =  if question.get('di_location')? then question.get('di_location') else 'Top'


      if !questionToDisplayInTwoPane and diLocation == 'Top'
        Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionSingleView(model: question))
      else
        Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionTwoPaneView(model: question))

    showActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.QuestionActionBarView(model: @quiz, section_index: @sectionIndex))

    startSection: (section,fromStart) ->
      #TODO show section view first and then show questions
      @currentSection = section
      @sectionIndex = @currentSectionCollection.indexOf(section)+1 if @currentSectionCollection
      @currentQuestionCollection = section.get('questions')
      if fromStart
        Gre340.Routing.showRouteWithTrigger('test_center','question',@currentQuestionCollection.first().get('id'))
      else
        Gre340.Routing.showRouteWithTrigger('test_center','question',@currentQuestionCollection.last().get('id'))
    startNextSection: ()->
      @startSection(@currentSectionCollection.next(@currentSection),true)
    startPrevSection: ()->
      @startSection(@currentSectionCollection.prev(@currentSection),false)
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
  #listen to all the events that matter to us
  Gre340.vent.on "show:next:question", ->
    controller = Controllers.questionController
    if controller.currentQuestionCollection?
      if controller.currentQuestionCollection.length-1 == controller.currentQuestionCollection.indexOf(controller.currentQuestion)
        #just a hack - indexOf was returning -1 instead of 0 for the first model so we first find the model and than restore it
        controller.currentSection = controller.currentSectionCollection.get(controller.currentSection)
        controller.startNextSection() if controller.currentSectionCollection.indexOf(controller.currentSection) != controller.currentSectionCollection.length-1
      else
        controller.currentQuestion = controller.currentQuestionCollection.next(controller.currentQuestion)
        Gre340.Routing.showRouteWithTrigger('test_center','question',controller.currentQuestion.get('id'))

  Gre340.vent.on "show:prev:question", ->
    controller = Controllers.questionController
    if controller.currentQuestionCollection?
      if controller.currentQuestionCollection.indexOf(controller.currentQuestion) == 0
        controller.startPrevSection() if controller.currentSectionCollection.indexOf(controller.currentSection) != 0
      else
        controller.currentQuestion = controller.currentQuestionCollection.prev(controller.currentQuestion)
        Gre340.Routing.showRouteWithTrigger('test_center','question',controller.currentQuestion.get('id'))


  Gre340.vent.on "quiz:changed", (quiz) ->
    if Controllers.questionController.getCurrentSection()?
      if Controllers.questionController.getCurrentQuestion()?
        Controllers.questionController.showQuestion(Controllers.questionController.getCurrentQuestion().get('id'))
      else
        Controllers.questionController.startSection(Controllers.questionController.getCurrentSection(),true)
    else
      Controllers.questionController.setCurrentSectionCollection(quiz.get('sections'))
      Controllers.questionController.startSection(Controllers.questionController.getCurrentSectionCollection().first(),true)

  Controllers.addInitializer ->
    Controllers.questionController = new QuestionController()

  Controllers.addFinalizer ->
      console.log 'stopped controller testcenter'