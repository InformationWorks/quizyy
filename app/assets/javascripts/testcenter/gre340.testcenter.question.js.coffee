Gre340.module "TestCenter.Question", (QuestionModule, Gre340, Backbone, Marionette, $, _) ->
  Question  = Backbone.Model.extend()

  QuestionCollection = Backbone.Collection.extend(
    model:Question
    url: '/questions.json'
  )

  QuestionSingleView = Marionette.ItemView.extend
    template: 'question/single'
    tagName: "div"
    className: "single"

  QuestionActionBarView = Marionette.ItemView.extend
    template: 'actionbar'

  class QuestionController
    constructor: () ->

    start:() ->
      @showQuestion()
      @showActionBar()

    showQuestion:() ->
      Gre340.TestCenter.Layout.layout.content.show(new QuestionSingleView)

    showActionBar: () ->
      Gre340.TestCenter.Layout.layout.actionbar.show(new QuestionActionBarView)

    getQuestionById: (id) ->
      console.log 'this tries to get question'

  QuestionModule.addInitializer ->
    QuestionModule.controller = new QuestionController()

