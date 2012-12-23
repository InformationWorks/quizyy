Gre340.module "TestCenter.Controllers", (Controllers, Gre340, Backbone, Marionette, $, _) ->
  class QuestionController
    constructor: () ->
      @Views = Gre340.TestCenter.Views
      @models = Gre340.TestCenter.Models
      @typesToDiplayInTwoPane = ['V-MCQ-1','V-MCQ-2','V-SIP','Q-DI-MCQ-1','Q-DI-MCQ-2','Q-DI-NE-1','Q-DI-NE-2']

    start:() ->
      @questionCollection.fetch()
    showQuestion:(question_id) ->
      @showActionBar()
      #if collection is empty
      if @questionCollection.length == 0
        @questionCollection.fetch(async:false)
      #see if the question should be displayed in two pane oTesr single
      question = @questionCollection.get(question_id)
      @currentQuestion = question
      questionToDisplayInTwoPane = _.find @typesToDiplayInTwoPane, (code) ->
        if(code==question.get('type').code)
          return true

      #check for Data Interpretation question location top (single pane) or side (two pane)
      if question.get('di_location') != null
        diLocation = question.get('di_location')
      else
        diLocation = 'Top'

      if(!questionToDisplayInTwoPane && diLocation == 'Top')
        Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionSingleView(model: question))
      else
        Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionTwoPaneView(model: question))

    showActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.QuestionActionBarView)

    getQuestionById: (id) ->
      console.log 'this tries to get question'
    setQuestionCollection: (collection) ->
       @questionCollection = collection

  Gre340.vent.on "show:next:question", ->
    controller = Controllers.questionController
    controller.currentQuestion = controller.questionCollection.next(controller.currentQuestion)
    Gre340.Routing.showRouteWithTrigger('test_center','question',controller.currentQuestion.get('id'))


  Controllers.addInitializer ->
    Controllers.questionController = new QuestionController()
    Controllers.questionController.setQuestionCollection(new Gre340.TestCenter.Models.QuestionCollection())
    Controllers.questionController.questionCollection.on "reset", (list) ->
      if !Controllers.questionController.currentQuestion
        Controllers.questionController.currentQuestion = list.first()
      Controllers.questionController.showQuestion(Controllers.questionController.currentQuestion)

  Controllers.addFinalizer ->
      console.log 'stopped controller testcenter'