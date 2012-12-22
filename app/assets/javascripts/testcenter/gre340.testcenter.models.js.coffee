Gre340.module "TestCenter.Models", (Models, Gre340, Backbone, Marionette, $, _) ->
  Models.Question  = Backbone.Model.extend()

  Models.QuestionCollection = Backbone.Collection.extend(
    model:Models.Question
    url: '/quizzes/1/sections/1/questions.json'
  )