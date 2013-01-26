Gre340.module "Cart.Views", (Views, Gre340, Backbone, Marionette, $, _) ->
  Views.CartItemView = Marionette.ItemView.extend
    model: 'Gre340.Cart.Data.Models.CardItem'
    template: 'cart/cart-item'
    tagName: "tr"

  Views.Cart = Marionette.CompositeView.extend
    initialize:(options) ->
      @collection = Gre340.Cart.Data.cart
      @collection.reset($('#cart-wrapper').data('cart'),{silent:false})
    template: 'cart/cart'
    templateHelpers:->
      'count': @collection.length
    itemView: Views.CartItemView
    itemViewContainer: "tbody"
    collection: @collection
    collectionEvents:
      "reset": "collectionChanged"
    collectionChanged:()->
      console.log 'reset'


  Views.addInitializer ->
    Views.cartView = new Views.Cart()
    Gre340.Cart.Layout.layout.cart.show(Views.cartView)
    $('.add-cart-btn').click ->
      Gre340.vent.trigger "add:cart:item"
