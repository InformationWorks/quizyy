# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
	$('.passage_show_link').click (e)->
		e.preventDefault()
		passage = $(this).next()
		passage.toggle()
		if passage.css('display') == 'none'
			$(this).text($(this).text().replace('hide', 'show'))
		else
			$(this).text($(this).text().replace('show', 'hide'))