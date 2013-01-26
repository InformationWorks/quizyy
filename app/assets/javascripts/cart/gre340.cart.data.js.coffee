Gre340.module "Cart.Data", (Data, Gre340, Backbone, Marionette, $, _) ->
  Data.Models = {}
  Data.Collections = {}

  Data.Models.CartItem = Backbone.Model.extend
    url:'/cart_items'
    initialize:(options)->

  Data.Collections.Cart = Backbone.Collection.extend
    model:Data.Models.CartItem
    initialize:->

  Data.addInitializer ->
    Data.cart = new Data.Collections.Cart

