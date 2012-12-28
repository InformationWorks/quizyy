Gre340.module "TestCenter.Data", (Data, Gre340, Backbone, Marionette, $, _) ->
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
  )

  Data.Models.Attempt = Backbone.Model.extend(
    url: '/quizzes/get_current_attempt'
    initialize:->
      @on 'change',(attempt) ->
        Gre340.vent.trigger('attempt:change', attempt)
  )

  Data.addInitializer ->
    Data.currentAttempt = new Data.Models.Attempt()