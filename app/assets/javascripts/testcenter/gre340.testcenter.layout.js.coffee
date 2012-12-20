Gre340.module "TestCenter.Layout",  (TestCenterLayout, Gre340, Backbone, Marionette, $, _) ->

  # The application layout

  TestCenterLayout.Layout = Backbone.Marionette.Layout.extend(
    template: 'testcenter-layout'
    regions:
      actionbar: '#action-bar'
      content: '#content'
  )

  TestCenterLayout.addInitializer ->
    TestCenterLayout.layout = new TestCenterLayout.Layout()
    Gre340.mainRegion.show TestCenterLayout.layout