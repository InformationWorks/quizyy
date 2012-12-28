# Trigger file upload dialog when image is clicked.
$ ->
  $("#profile-image").click ->
    $("#profile_pic_uploader").trigger "click"

# Call back function to handle image upload via jquery-fileupload/basic
$ ->
  console.log "Setting up function for uploding via jquery"
  $("#profile_pic_uploader").fileupload
    autoUpload: true
    dataType: "json"
    done: (e, data) ->
      if data.result.status is "true"
        profile_image = document.getElementById("profile-image")
        profile_image.src = data.result.imageurl
      else
        alert "Sorry couldn't upload file. Try again later"
        
# Tab selection toggled.
$ ->
  $("#available-test-tabs a").click (e) ->
    e.preventDefault()
    $(this).tab "show"

# Hover on test list item.
$ ->
  $(".test-list li").on
    mouseenter: ->
      $(this).find(".command-btn").show()

    mouseleave: ->
      $(this).find(".command-btn").hide()
      
# Remove profile image button click
$ ->
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