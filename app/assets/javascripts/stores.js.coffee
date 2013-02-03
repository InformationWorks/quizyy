$(document).ready ->
  $(".flip").click(->
    console.log 'flip is clicked'
    $(this).find(".card").addClass "flipped"
    false).mouseleave ->
      $(".flip > .card").removeClass "flipped"

  frontHeight = $(".front").outerHeight()
  backHeight = $(".back").outerHeight()
  if frontHeight > backHeight
    $(".flip, .back").height frontHeight
  else if frontHeight > backHeight
    $(".flip, .front").height backHeight
  else
    $(".flip").height backHeight