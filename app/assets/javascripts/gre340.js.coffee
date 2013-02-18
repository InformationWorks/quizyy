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

String.prototype.replaceImageTag = ->
  if /<image[^>]*>(.*?)<\/image>/.test(this)
    console.log 'image is found'
    img_regex = /<image[^>]*>(.*?)<\/image>/gi
    result = []
    img_names = {}
    while ( (result = img_regex.exec(this)) )
      img_names[result[1]]=result[0]
    this.replace(new RegExp(image_tag,'g'),"<br/><img src="+image_name+"><br/>") for image_name,image_tag of img_names

String.prototype.replaceBlankTag = ->
  if /<BLANK-[A-Z]*>/gi.test(this)
    this.replace(/<BLANK-[A-Z]*>/gi,'<span class="blank"></span>')