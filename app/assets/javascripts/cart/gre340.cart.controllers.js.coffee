Gre340.module "Cart.Controllers", (Controllers, Gre340, Backbone, Marionette, $, _) ->
  class CartsController
    constructor:()->

  Controllers.addInitializer ->
    Controllers.cartsController = new CartsController()