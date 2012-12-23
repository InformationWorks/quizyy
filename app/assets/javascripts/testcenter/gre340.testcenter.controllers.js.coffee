Gre340.module "TestCenter.Controllers", (Controllers, Gre340, Backbone, Marionette, $, _) ->
  class QuestionController
    constructor: () ->
      @Views = Gre340.TestCenter.Views
      @models = Gre340.TestCenter.Models
      @typesToDiplayInTwoPane = ['V-MCQ-1','V-MCQ-2','V-SIP','Q-DI-MCQ-1','Q-DI-MCQ-2','Q-DI-NE-1','Q-DI-NE-2']

    start:() ->
      @showActionBar()

    showQuestion:(question) ->
      #see if the question should be displayed in two pane oTesr single
      questionToDisplayInTwoPane = _.find @typesToDiplayInTwoPane, (code) ->
        if(code==question.get('type').code)
          return true

      #check for Data Interpretation question location top (single pane) or side (two pane)
      if question.get('di_location') != null
        diLocation = question.get('di_location')
      else
        diLocation = 'Top'

      if(!questionToDisplayInTwoPane && diLocation == 'Side')
        Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionSingleView(model: question))
      else
        Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionTwoPaneView(model: question))

    showActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.QuestionActionBarView)

    getQuestionById: (id) ->
      console.log 'this tries to get question'

  Controllers.addInitializer ->
    Controllers.questionController = new QuestionController()
    Gre340.TestCenter.questionList = new Gre340.TestCenter.Models.QuestionCollection()
    Gre340.TestCenter.questionList.on "reset", (list) ->
      Controllers.questionController.showQuestion(list.first())
    Gre340.TestCenter.questionList.fetch()
