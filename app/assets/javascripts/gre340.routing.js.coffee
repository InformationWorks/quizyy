Gre340.module "Routing", (Routing, Gre340, Backbone, Marionette, $, _) ->
  # Public API
  # ----------

  # The `showRoute` method is a private method used to update the
  # url's hash fragment route. It accepts a base route and an
  # unlimited number of optional parameters for the route:
  # `showRoute("foo", "bar", "baz", "etc");`.
  Routing.showRoute = ->
    route = getRoutePath(arguments)
    Backbone.history.navigate route, trigger: false

  Routing.showRouteWithTrigger = ->
    route = getRoutePath(arguments)
    Backbone.history.navigate route, trigger: true

  # Helper Methods
  # --------------

  # Creates a proper route based on the `routeParts`
  # that are passed to it.
  getRoutePath = (routeParts) ->
    base = routeParts[0]
    length = routeParts.length
    route = base
    if length > 1
      i = 1

      while i < length
        arg = routeParts[i]
        route = route + "/" + arg  if arg
        i++
    route

  Router = Backbone.Router.extend(
    routes:
      'homes/index': 'goToAvailableTest'
      'stores/*anything': 'initCart'
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
    showIndex: ->
      if !Gre340.TestCenter.Controllers.questionController.isStarted
        Gre340.TestCenter.Controllers.questionController.start()
      Gre340.Routing.showRoute('/test_center/index')
    showQuestion: (sectionNumber,questionNumber) ->
      if !Gre340.TestCenter.Controllers.questionController.isStarted
        Gre340.TestCenter.Controllers.questionController.start()
      q = Gre340.TestCenter.Controllers.questionController
      q.showQuestionByNumber(sectionNumber,questionNumber)
    showSection: (sectionNumber) ->
      if !Gre340.TestCenter.Controllers.questionController.isStarted
        Gre340.TestCenter.Controllers.questionController.start()
      q = Gre340.TestCenter.Controllers.questionController
      q.startSectionByNumber(sectionNumber,null)
    exitSection: (sectionNumber) ->
      if !Gre340.TestCenter.Controllers.questionController.isStarted
        Gre340.TestCenter.Controllers.questionController.start()
      q = Gre340.TestCenter.Controllers.questionController
      q.exitSection()
    stopAllModules:()->
      Gre340.TestCenter.stop()
      Gre340.Cart.stop()
    showError:()->

    showReport:()->
      q = Gre340.TestCenter.Controllers.questionController
      if !q.isStarted
        q.start()
      q.submitQuiz()
    goToAvailableTest: () ->
      @stopAllModules()
      if !Modernizr.mq("screen and (min-width: 1200px)")
        scrollToElement("#available-tests")
    initCart:()->
      Gre340.TestCenter.stop()
      console.log 'cart initiaze'
  )

  Routing.addInitializer ->
    router = new Router()
  Routing.addFinalizer ->
    console.log 'stopped routing testcenter'