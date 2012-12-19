Gre340.module "TestCenter", (TestCenter, Gre340, Backbone, Marionette, $, _) ->
  startWithParent: false,
  define:
    TestCenter.showIndex = ->
      #alert 'wohoo this is working'