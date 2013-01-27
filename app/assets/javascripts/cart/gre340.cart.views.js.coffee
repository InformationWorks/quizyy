Gre340.module "Cart.Views", (Views, Gre340, Backbone, Marionette, $, _) ->
  Views.CartItemView = Marionette.ItemView.extend
    model: 'Gre340.Cart.Data.Models.CardItem'
    template: 'cart/cart-item'
    tagName: "tr"

  Views.Cart = Marionette.CompositeView.extend
    initialize:(options) ->
      @collection = Gre340.Cart.Data.cart
      @collection.reset($('#cart-wrapper').data('cart'),{silent:false})
      Gre340.vent.on "add:cart:item", @addItemToCart, @
      Gre340.vent.on "remove:cart:item",@removeItemFromCart,@
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
    addItemToCart:(quiz_id,el)->
      cartItem = new Gre340.Cart.Data.Models.CartItem
        quiz_id:quiz_id
      cartItem.save null,
        success:(model,response,options)=>
          if response.success
            @collection.add(model)
            removeBtn = _.template('<a href="#" rel="tooltip" class="btn remove-cart-btn" title="Remove from Cart" data-disabled-with="removing.." data-value="<%= quiz_id %>" data-id="<%=id %>"><span class="icon-remove"></span></a>',model.attributes)
            $(el).tooltip('destroy')
            $(el).after(removeBtn)
            $(el).remove()
            $(removeBtn).tooltip('show')
          else
            alert 'An error occured while adding the quiz to cart. Please try again later.'
        error:@handleErrors
    removeItemFromCart:(model_id,el)->
      @collection.get(model_id).destroy
        params:
          id:model_id
        success:(model,response,options)=>
          if response.success
            addBtn = _.template('<a href="#" rel="tooltip" class="btn add-cart-btn" title="Add to Cart" data-disabled-with="adding.." data-value="<%=quiz.id%>"><span class="icon-plus"></span></a>',model.attributes)
            $(el).tooltip('destroy')
            $(el).after(addBtn)
            $(el).remove()
            $(addBtn).tooltip('show')
          else
            alert 'An error occured while removing the quiz from the cart. Please try again later.'
        error:@handleErrors
    handleError: (entry, response) ->
      alert 'Some error occured. Please try again later.'
  Views.addInitializer ->
    Views.cartView = new Views.Cart()
    Gre340.Cart.Layout.layout.cart.show(Views.cartView)
    $('body').on 'click','a.add-cart-btn',(event)->
      event.preventDefault()
      Gre340.vent.trigger "add:cart:item",$(@).data('value'),@

    $('body').on 'click','a.remove-cart-btn', (event)->
      event.preventDefault()
      Gre340.vent.trigger "remove:cart:item",$(@).data('id'),@

    $('body').tooltip
      selector: '[rel=tooltip]'
