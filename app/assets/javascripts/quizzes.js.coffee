refresh_dropdown = ->
    quiz_type = $("#quiz_type_select :selected").text()
    if quiz_type is 'FullQuiz'
      $("#category_select").hide()
      $("#topic_select").hide()
      $("#section_type_select").hide()
    else if quiz_type is 'CategoryQuiz'
      $("#category_select").show()
      $("#topic_select").hide()
      $("#section_type_select").hide()
    else if quiz_type is 'TopicQuiz'
      $("#category_select").hide()
      $("#topic_select").show()
      $("#section_type_select").hide()
    else if quiz_type is 'SectionQuiz'
      $("#category_select").hide()
      $("#topic_select").hide()
      $("#section_type_select").show()

initPage = ->
  
  # Refresh for initial load
  refresh_dropdown()
  
  $("#quiz_type_select").change ->
    refresh_dropdown()
      
# Trigger file upload dialog when image is clicked.

$(window).bind 'page:change', ->
  initPage()

$(document).ready ->
  initPage()

