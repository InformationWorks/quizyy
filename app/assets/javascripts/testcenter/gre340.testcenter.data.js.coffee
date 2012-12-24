Gre340.module "TestCenter.Data", (Data, Gre340, Backbone, Marionette, $, _) ->
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

  Data.Models = {}
  Data.Collections = {}

  Data.Models.Question  = Backbone.AssociatedModel.extend()

  Data.Collections.QuestionCollection = Backbone.Collection.extend(
    model:Data.Models.Question
    next : (model) -> @at(this.indexOf(model) + 1)
    prev : (model) -> @at(this.indexOf(model) - 1)
  )

  Data.Models.Section = Backbone.AssociatedModel.extend(
    relations: [
      type: Backbone.Many
      key: 'questions'
      relatedModel:'Gre340.TestCenter.Data.Models.Question'
      collectionType:'Gre340.TestCenter.Data.Collections.QuestionCollection'
    ]
  )

  Data.Collections.SectionCollection = Backbone.Collection.extend(
    model: Data.Models.Section
    next : (model) -> @at(this.indexOf(model) + 1)
    prev : (model) -> @at(this.indexOf(model) - 1)
  )

  Data.Models.Quiz = Backbone.AssociatedModel.extend(
    initialize:->
      @on 'change',(quiz) ->
        Gre340.vent.trigger('quiz:changed', quiz)
    relations: [
      type: Backbone.Many
      key: 'sections'
      relatedModel:'Gre340.TestCenter.Data.Models.Section'
      collectionType:'Gre340.TestCenter.Data.Collections.SectionCollection'
    ]
    url: '/quizzes/'+getCookie('current_quiz_id')+'.json'
  )

  Data