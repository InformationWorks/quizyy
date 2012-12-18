Gre340.module "TestCenter.App", (TestCenter, Gre340, Backbone, Marionette, $, _) ->
  startWithParent: false,
  define:
    TestCenter.showIndex = ->
      alert 'wohoo this is working'