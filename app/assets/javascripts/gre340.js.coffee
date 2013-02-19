@Gre340 = new Backbone.Marionette.Application()

Gre340.addInitializer (options) ->
  Gre340.addRegions mainRegion: "#container"
  Gre340.addRegions cartRegion: "#cart-wrapper"

Gre340.on "initialize:after", ->
  if(history.pushState) 
  	Backbone.history.start(pushState:true)  if Backbone.history
  else
  	Backbone.history.start(pushState:false) if Backbone.history	
$(document).ready ->	
	Gre340.start()
	if !history.pushState
		$('#unsupported').modal('show')
$(document).on('page:fetch', (event) -> $('#loading').show())
$(document).on('page:change',(event) -> $('#loading').hide())