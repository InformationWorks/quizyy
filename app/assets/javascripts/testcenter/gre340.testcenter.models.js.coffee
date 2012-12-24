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
    next : (model) -> @at(this.indexOf(model) + 1),
    prev : (model) -> @at(this.indexOf(model) - 1)
  )

  Models.Section = Backbone.AssociatedModel.extend(
    relations: [
      type: Backbone.Many,
      key: 'questions',
      relatedModel:'Gre340.TestCenter.Models.Question'
      collectionType:'Gre340.TestCenter.Models.QuestionCollection'
    ]
  )

  Models.SectionCollection = Backbone.Collection.extend(
    model: Models.Section
  )
  Models.Quiz = Backbone.AssociatedModel.extend(
    relations: [
      type: Backbone.Many,
      key: 'sections',
      relatedModel:'Gre340.TestCenter.Models.Section'
      collectionType:'Gre340.TestCenter.Models.SectionCollection'
    ],
    url: '/quizzes/'+getCookie('current_quiz_id')+'.json'
  )
  Models