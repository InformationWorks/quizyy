Gre340.module "Routing.TestCenterRouting", (TestCenterRouting, Gre340, Backbone, Marionette, $, _) ->

  Router = Backbone.Router.extend(
    routes:
      'test_center': 'showIndex'
      'test_center/index?quiz_id=:id': 'showIndex'
      'test_center/index': 'showIndex'
      'test_center/section/:sindex/question/:qindex': 'showQuestion'
      '*anyotherpath': 'stopAllModules'

    before:(route) ->
      Gre340.TestCenter = Gre340.module("TestCenter");
      Gre340.TestCenter.start()
    showIndex: ->
      Gre340.Routing.showRoute('/test_center/index')
      Gre340.TestCenter.Controllers.questionController.start()
    showQuestion: (sectionNumber,questionNumber) ->
      qController = Gre340.TestCenter.Controllers.questionController
      qController.showQuestionByNumber(sectionNumber,questionNumber)
    stopAllModules:()->
      Gre340.TestCenter.stop()
  )

  TestCenterRouting.addInitializer ->
      router = new Router()
  TestCenterRouting.addFinalizer ->
    console.log 'stopped routing testcenter'