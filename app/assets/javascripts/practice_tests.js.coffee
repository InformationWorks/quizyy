initPage = ->
  ->
  $(".quiz-tile").on
    mouseenter: ->
      $(this).find(".actions").show()
  
    mouseleave: ->
      $(this).find(".actions").hide()
      
$(window).bind 'page:change', ->
  initPage()

$(document).ready ->
  initPage()