Gre340.module "Routing.TestCenterRouting", (TestCenterRouting, Gre340, Backbone, Marionette, $, _) ->

  Router = Backbone.Router.extend(
    routes:
      'homes/index': 'goToAvailableTest'
      'test_center/error': 'showError'
      'test_center/index?quiz_id=:id': 'showIndex'
      'test_center/section/:sindex/question/:qindex': 'showQuestion'
      'test_center/section/:sindex/exit': 'exitSection'
      'test_center/section/:sindex': 'showSection'
      'test_center/submit': 'showReport'
      'test_center/*anything': 'showIndex'
      'test_center': 'showIndex'
      '*anyotherpath': 'stopAllModules'

    before:(route) ->
      Gre340.TestCenter = Gre340.module("TestCenter");
      Gre340.TestCenter.start()
      if !Gre340.TestCenter.Controllers.questionController.isStarted
        Gre340.TestCenter.Controllers.questionController.start()
    showIndex: ->
      Gre340.Routing.showRoute('/test_center/index')
    showQuestion: (sectionNumber,questionNumber) ->
      q = Gre340.TestCenter.Controllers.questionController
      q.showQuestionByNumber(sectionNumber,questionNumber)
    showSection: (sectionNumber) ->
      console.log 'show section is called'
      q = Gre340.TestCenter.Controllers.questionController
      q.startSectionByNumber(sectionNumber,null)
    exitSection: (sectionNumber) ->
      q = Gre340.TestCenter.Controllers.questionController
      q.exitSection()
    stopAllModules:()->
      Gre340.TestCenter.stop()
    showError:()->

    showReport:()->
      q = Gre340.TestCenter.Controllers.questionController
      q.submitQuiz()
      alert 'The test has been submitted.'
    goToAvailableTest: () ->
      @stopAllModules()
      if !Modernizr.mq("screen and (min-width: 1200px)")
        scrollToElement("#available-tests")
  )

  TestCenterRouting.addInitializer ->
      router = new Router()
  TestCenterRouting.addFinalizer ->
    console.log 'stopped routing testcenter'