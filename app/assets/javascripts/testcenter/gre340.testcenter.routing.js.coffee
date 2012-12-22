Gre340.module "Routing.TestCenterRouting", (TestCenterRouting, Gre340, Backbone, Marionette, $, _) ->

  Router = Backbone.Router.extend(
    routes:
      'test_center': 'showIndex'
      'test_center/': 'showIndex'
      'test_center/:id': 'showIndex'
    before:(route) ->
      Gre340.TestCenter = Gre340.module("TestCenter");
      Gre340.TestCenter.start()
    showIndex: ->
      Gre340.TestCenter.Controllers.questionController.start()
  )

  TestCenterRouting.addInitializer ->
      router = new Router()
