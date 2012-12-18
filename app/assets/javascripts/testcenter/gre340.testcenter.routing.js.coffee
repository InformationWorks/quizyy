Gre340.module "Routing.TestCenterRouting", (TestCenterRouting, Gre340, Backbone, Marionette, $, _) ->
  TestCenterRouting.Router = Backbone.Marionette.AppRouter.extend(appRoutes:
    '': 'showIndex'
    'index': 'showIndex'
    'questions/:id': 'showIndex'
  )

  TestCenterRouting.addInitializer ->
    Gre340.TestCenter = Gre340.module("TestCenter.App");
    Gre340.TestCenter.start()
    TestCenterRouting.router = new TestCenterRouting.Router(
      controller: Gre340.TestCenter
    )