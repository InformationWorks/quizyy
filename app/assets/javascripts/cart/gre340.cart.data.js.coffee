Gre340.module "Cart.Data", (Data, Gre340, Backbone, Marionette, $, _) ->
  Data.Models = {}
  Data.Collections = {}

  Data.Models.CartItem = Backbone.Model.extend
    urlRoot:'/cart_items'
    parse : (response)->
      JSON.parse(response.data)
    initialize:(options)->

  Data.Collections.Cart = Backbone.Collection.extend
    model:Data.Models.CartItem
    initialize:->

  Data.addInitializer ->
    Data.cart = new Data.Collections.Cart
  Data.addFinalizer ->
    Data.cart.reset()
    Data.cart = null
