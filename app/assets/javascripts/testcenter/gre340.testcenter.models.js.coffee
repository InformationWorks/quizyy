Gre340.module "TestCenter.Models", (Models, Gre340, Backbone, Marionette, $, _) ->
  #sorce w2school
  getCookie = (c_name) ->
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

  Models.Question  = Backbone.Model.extend()

  Models.QuestionCollection = Backbone.Collection.extend(
    model:Models.Question,
    url:'/quizzes/'+getCookie('current_quiz_id')+'/sections/1/questions.json'
    next : (model) -> @at(this.indexOf(model) + 1),
    prev : (model) -> @at(this.indexOf(model) - 1)
  )

  Models