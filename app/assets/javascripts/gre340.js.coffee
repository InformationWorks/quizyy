@Gre340 = new Backbone.Marionette.Application()

Gre340.on "initialize:after", ->
  Backbone.history.start()  if Backbone.history

$(document).ready ->
  Gre340.start()
