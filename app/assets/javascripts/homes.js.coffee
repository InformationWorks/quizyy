initPage = ->
  ->
  $("#profile-image").click ->
    $("#profile_pic_uploader").trigger "click"

  # Call back function to handle image upload via jquery-fileupload/basic
  $("#profile_pic_uploader").fileupload
    autoUpload: true
    dataType: "json"
    start: (e) ->
      console.log "TODO: Start spinner for uploading profile image"
    done: (e, data) ->
      console.log "TODO: Stop spinner for uploading profile image"
      if data.result.status is "true"
        profile_image = document.getElementById("profile-image")
        profile_image.src = data.result.imageurl
      else
        alert "Sorry couldn't upload file. Try again later"

  # Tab selection toggled.
  $("#available-test-tabs a").click (e) ->
    e.preventDefault()
    $(this).tab "show"

  # Hover on test list item.
  $(".test-list li").on
    mouseenter: ->
      $(this).find(".command-btn").show()

    mouseleave: ->
      $(this).find(".command-btn").hide()

  $("#remove-image-btn").click ->
    if(confirm("Are you sure you want to remove the image?"))
      $.ajax
        url: "/users/profiles/remove_profile_pic"
        type: "POST"
        data:
          field: "val"
          _method:'delete'
        dataType: "json"
        success: (resp) ->
          if resp.status == "true"
            profile_image = document.getElementById("profile-image")
            profile_image.src = "/assets/metro-user.png"
          else
            alert "Unable to remove image right now. Try again later."
# Trigger file upload dialog when image is clicked.

$(window).bind('page:change', ->
  initPage()
)

$(document).ready( ->
  initPage()
)

