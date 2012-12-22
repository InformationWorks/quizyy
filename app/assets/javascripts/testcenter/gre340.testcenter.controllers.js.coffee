Gre340.module "TestCenter.Controllers", (Controllers, Gre340, Backbone, Marionette, $, _) ->
  class QuestionController
    constructor: () ->
      @Views = Gre340.TestCenter.Views

    start:() ->
      @showQuestion()
      @showActionBar()

    showQuestion:() ->
      Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionSingleView)
      #Gre340.TestCenter.Layout.layout.content.show(new @Views.QuestionTwoPaneView)
    showActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new @Views.QuestionActionBarView)

    getQuestionById: (id) ->
      console.log 'this tries to get question'

  Controllers.addInitializer ->
    Controllers.questionController = new QuestionController()