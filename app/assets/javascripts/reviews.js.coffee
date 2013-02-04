# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
	$("body").scrollspy(offset: 300)
	$("#sidebar li").on('activate', (event) ->
    	$('#sidebar').scrollTop(event.target.offsetTop)
	)