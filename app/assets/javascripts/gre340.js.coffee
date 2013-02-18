@Gre340 = new Backbone.Marionette.Application()

Gre340.addInitializer (options) ->
  Gre340.addRegions mainRegion: "#container"
  Gre340.addRegions cartRegion: "#cart-wrapper"

Gre340.on "initialize:after", ->
  Backbone.history.start(pushState:true)  if Backbone.history

$(document).ready ->
  Gre340.start()
$(document).on('page:fetch', (event) -> $('#loading').show())
$(document).on('page:change',(event) -> $('#loading').hide())