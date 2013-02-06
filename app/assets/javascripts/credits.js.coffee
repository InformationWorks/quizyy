# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
check_custom_desc_add = ->
    desc_dropdown_text = $("#credits_add_desc_dropdown :selected").text()
    if desc_dropdown_text is 'Custom'
      $("#credits_add_custom_desc").show()
    else
      $("#credits_add_custom_desc").hide()
      
check_custom_desc_remove = ->
    desc_dropdown_text = $("#credits_remove_desc_dropdown :selected").text()
    if desc_dropdown_text is 'Custom'
      $("#credits_remove_custom_desc").show()
    else
      $("#credits_remove_custom_desc").hide()
      
initPage = ->
  
  check_custom_desc_add()
  check_custom_desc_remove()
  
  $("#credits_add_desc_dropdown").change ->
    check_custom_desc_add()
  
  $("#credits_remove_desc_dropdown").change ->
    check_custom_desc_remove()
        
# Trigger file upload dialog when image is clicked.

$(window).bind 'page:change', ->
  initPage()

$(document).ready ->
  initPage()
