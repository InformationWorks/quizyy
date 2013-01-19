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
    initialize:->
      currentQuestion = null
    next : (model) -> @at(this.indexOf(model) + 1)
    prev : (model) -> @at(this.indexOf(model) - 1)
    comparator:(item) ->
      item.get('sequence_no')
  
  Data.Models.Section = Backbone.AssociatedModel.extend
    initialize:->
      currentSection = null
    relations: [
      type: Backbone.Many
      key: 'questions'
      relatedModel:'Gre340.TestCenter.Data.Models.Question'
      collectionType:'Gre340.TestCenter.Data.Collections.QuestionCollection'
    ]
  
  Data.Collections.SectionCollection = Backbone.Collection.extend
    model: Data.Models.Section
    next : (model) -> @at(@sortedIndex(@get(model.id),@comparator) + 1)
    prev : (model) -> @at(this.indexOf(model) - 1)
    comparator:(item) ->
      item.get('sequence_no')

  Data.Models.Quiz = Backbone.AssociatedModel.extend
    initialize:->
      @on 'change:id',(quiz) ->
        @currentSection = if Data.currentAttempt.getCurrentSectionId()==null then @get('sections').where(sequence_no: 1)[0] else @get('sections').get(Data.currentAttempt.getCurrentSectionId()) 
        @currentQuestionCollection = @currentSection.get('questions')
        @currentQuestion = if Data.currentAttempt.getCurrentQuestionId()==null then null else @currentQuestionCollection.get(Data.currentAttempt.getCurrentQuestionId())
        Gre340.vent.trigger 'quiz:changed', quiz
    relations: [
      type: Backbone.Many
      key: 'sections'
      relatedModel:'Gre340.TestCenter.Data.Models.Section'
      collectionType:'Gre340.TestCenter.Data.Collections.SectionCollection'
    ]
    setCurrentQuestionCollection:->
      if @length>0
        @currentQuestionCollection = @get('sections').get(Data.currentAttempt.getCurrentSectionId()).get('questions')
    setCurrentState:->
      @setCurrentQuestionCollection()
    setCurrentQuestion:->
      @currentQuestion = @getCurrentQuestionCollection().get(Data.currentAttempt.getCurrentQuestionId())
    getCurrentSection:->
      @currentSection
    getCurrentQuestion:->
      @currentQuestion 
    getCurrentSectionCollection: ->
      @get('sections')
    getCurrentQuestionCollection: ->
      @currentQuestionCollection
  
  Data.Models.Attempt = Backbone.Model.extend
    urlRoot: '/api/v1/attempts'
    initialize:(options)->
      Gre340.vent.on 'update:current:attempt', (currentSectionId, currentQuestionId) =>
        @updateCurrentAttempt(currentSectionId,currentQuestionId)
      Gre340.vent.on 'submit:current:attempt',() =>
        @completeAttempt()
      @on "change:id",(attempt)->
        Gre340.vent.trigger "attempt:changed",attempt
      @on "change:current_section_id",(attempt)->
        Gre340.vent.trigger "attempt:change:current_section_id",attempt
      @on "change:current_question_id",(attempt)->
        Gre340.vent.trigger "attempt:change:current_question_id",attempt
    updateCurrentAttempt: (currentSectionId,currentQuestionId) ->
      @set({'current_section_id': currentSectionId,'current_question_id': currentQuestionId},{silent: true})
      @save()
    completeAttempt:()->
      @set({'completed': true},{silent: true})
      @save()
    getCurrentSectionId:()->
      @get('current_section_id')
    getCurrentQuestionId:()->
      @get('current_question_id')
    isComplete:()->
      @get('completed') 
  
  Data.addInitializer ->
    Data.currentAttempt = new Data.Models.Attempt()
    Data.currentQuiz = new Data.Models.Quiz()
    Gre340.vent.on 'attempt:changed', (attempt) ->
      Data.currentQuiz.url = '/api/v1/quizzes/'+attempt.get('quiz_id')+'.json'
      Data.currentQuiz.fetch(async: true)
    