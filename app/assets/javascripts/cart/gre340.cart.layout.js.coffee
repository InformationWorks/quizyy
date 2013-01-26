Gre340.module "Cart.Layout",  (CartLayout, Gre340, Backbone, Marionette, $, _) ->

  # The application layout

  CartLayout.Layout = Backbone.Marionette.Layout.extend(
    template: 'cart/_layout'
    regions:
      cart: '#cart-section'
  )

  CartLayout.addInitializer ->
    CartLayout.layout = new CartLayout.Layout()
    Gre340.cartRegion.show CartLayout.layout
