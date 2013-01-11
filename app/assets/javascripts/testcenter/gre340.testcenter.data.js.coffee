Gre340.module "TestCenter.Data", (Data, Gre340, Backbone, Marionette, $, _) ->
  Data.Models = {}
  Data.Collections = {}

  Data.Models.Option = Backbone.AssociatedModel.extend
    initialize: (options)->
      @on('change:option',(option) -> console.log option)

  Data.Collections.OptionsCollection = Backbone.Collection.extend
    model: Data.Models.Option
    comparator:(item) ->
      item.get('sequence_no')

  Data.Models.Question  = Backbone.AssociatedModel.extend
    relations: [
      type: Backbone.Many
      key: 'options'
      relatedModel:'Gre340.TestCenter.Data.Models.Option'
      collectionType:'Gre340.TestCenter.Data.Collections.OptionsCollection'
    ]

  Data.Collections.QuestionCollection = Backbone.Collection.extend
    model:Data.Models.Question
    next : (model) -> @at(this.indexOf(model) + 1)
    prev : (model) -> @at(this.indexOf(model) - 1)
    comparator:(item) ->
      item.get('sequence_no')

  Data.Models.Section = Backbone.AssociatedModel.extend
    relations: [
      type: Backbone.Many
      key: 'questions'
      relatedModel:'Gre340.TestCenter.Data.Models.Question'
      collectionType:'Gre340.TestCenter.Data.Collections.QuestionCollection'
    ]


  Data.Collections.SectionCollection = Backbone.Collection.extend
    model: Data.Models.Section
    next : (model) -> @at(this.indexOf(model) + 1)
    prev : (model) -> @at(this.indexOf(model) - 1)
    comparator:(item) ->
      item.get('sequence_no')

  Data.Models.Quiz = Backbone.AssociatedModel.extend
    initialize:->
      @on 'change:id',(quiz) ->
        Gre340.vent.trigger('quiz:changed', quiz)
    relations: [
      type: Backbone.Many
      key: 'sections'
      relatedModel:'Gre340.TestCenter.Data.Models.Section'
      collectionType:'Gre340.TestCenter.Data.Collections.SectionCollection'
    ]

  Data.Models.Attempt = Backbone.Model.extend
    urlRoot: '/api/v1/attempts'
    initialize:(options)->
      @on 'change:id',(attempt) ->
        Gre340.vent.trigger('new:attempt', attempt)

  Data.addInitializer ->
    Data.currentAttempt = new Data.Models.Attempt()