Gre340.module "TestCenter.Layout",  (TestCenterLayout, Gre340, Backbone, Marionette, $, _) ->

  # The application layout

  TestCenterLayout = Backbone.Marionette.Layout.extend(
    template: 'testcenter_layout'

    regions:
      actions: '#top-action-bar'
      question: '#question'

    initialize: ->
  )

  Gre340.TestCenter.addInitializer ->
    Gre340.TestCenter.layout = new TestCenterLayout()
