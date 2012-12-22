Gre340.module "TestCenter.Controllers", (Controllers, Gre340, Backbone, Marionette, $, _) ->
  class QuestionController
    constructor: () ->
      @Views = Gre340.TestCenter.Views
      @models = Gre340.TestCenter.Models
    start:() ->
      @showActionBar()

    showQuestion:(list) ->
      Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionSingleView(model: list.first()))

    showActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.QuestionActionBarView)

    getQuestionById: (id) ->
      console.log 'this tries to get question'

  Controllers.addInitializer ->
    Controllers.questionController = new QuestionController()
    Gre340.TestCenter.questionList = new Gre340.TestCenter.Models.QuestionCollection()
    Gre340.TestCenter.questionList.on "reset", (list) ->
      Controllers.questionController.showQuestion(list)
    Gre340.TestCenter.questionList.fetch()
