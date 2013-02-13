Gre340.module "Cart.Views", (Views, Gre340, Backbone, Marionette, $, _) ->
  Views.CartItemView = Marionette.ItemView.extend
    model: 'Gre340.Cart.Data.Models.CartItem'
    template: 'cart/cart-item'
    tagName: "tr"
  Views.CartEmpty = Marionette.ItemView.extend
    template: 'cart/empty'
    tagName: 'td'
  Views.Cart = Marionette.CompositeView.extend
    initialize:(options) ->
      @collection = Gre340.Cart.Data.cart
      @collection.reset($('#cart-wrapper').data('cart'),{silent:false})
      @listenTo Gre340.vent,"add:cart:item",@addItemToCart,@
      @listenTo Gre340.vent,"remove:cart:item",@removeItemFromCart,@
      @
    events:
      'click .remove-cart-side-btn': 'removeItemFromCartEvent'
    template: 'cart/cart'
    templateHelpers:->
      'count': @collection.length
    itemView: Views.CartItemView
    itemViewContainer: "tbody"
    emptyView: Views.CartEmpty
    collection: @collection
    collectionEvents:
      "add": "collectionChanged"
      "remove": 'collectionChanged'
    collectionChanged:(event)->
      if @collection.length == 0
        $('#proceed-checkout-btn')[0].remove() if $('#proceed-checkout-btn').length > 0
      else
        $(@el).append('<a href="stores/cart" class="btn btn-success" id="proceed-checkout-btn">Proceed to checkout</a>') if $('#proceed-checkout-btn').length == 0
    onRender:()->
      @collectionChanged()
    addItemToCart:(quiz_id,package_id,remove_btn_template,el)->
      cartItem = new Gre340.Cart.Data.Models.CartItem
        quiz_id:quiz_id
        package_id:package_id
      cartItem.save null,
        success:(model,response,options)=>
          if response.success
            @collection.add(model)
            removeBtn = _.template(remove_btn_template,model.attributes)
            $(el).tooltip('destroy')
            $(el).after(removeBtn)
            $(el).remove()
            $(removeBtn).tooltip('show')
          else
            alert 'An error occured while adding the quiz to cart. Please try again later.'
        error:@handleErrors
    removeItemFromCartEvent:(event)->
      event.preventDefault()
      
      if $(event.currentTarget).data('item-type') is "quiz"
        add_btn_template = '<a href="#" rel="tooltip" class="btn add-cart-btn" data-disabled-with="adding.." data-item-type="quiz" data-value="<%= quiz_id %>" data-original-title="Add to Cart"><span class="icon-plus"></span></a>'
      else
        add_btn_template = '<a href="#" rel="tooltip" class="btn add-cart-btn" data-disabled-with="adding.." data-item-type="package" data-value="<%= package_id %>" data-original-title="Add to Cart"><span class="icon-plus"></span></a>'
      
      remove_btn = $(".remove-cart-btn[data-id='"+$(event.currentTarget).data('id')+ "']")
      
      @removeItemFromCart($(event.currentTarget).data('id'),add_btn_template,remove_btn)
    removeItemFromCart:(model_id,add_btn_template,el)->
      @collection.get(model_id).destroy
        params:
          id:model_id
        success:(model,response,options)=>
          if response.success
            addBtn = _.template(add_btn_template,model.attributes)
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
    
    # Add cart-item event.
    $('body').on 'click','a.add-cart-btn',(event)->
      event.preventDefault()
      
      if $(@).data('item-type') is "quiz"
        quiz_id = $(@).data('value')
        package_id = null
        remove_btn_template = '<a href="#" rel="tooltip" class="btn remove-cart-btn" title="Remove from Cart" data-disabled-with="removing.." data-item-type="quiz" data-id="<%=id%>"><span class="icon-remove"></span></a>'
      else
        quiz_id = null
        package_id = $(@).data('value')
        remove_btn_template = '<a href="#" rel="tooltip" class="btn remove-cart-btn" title="Remove from Cart" data-disabled-with="removing.." data-item-type="package" data-id="<%=id%>"><span class="icon-remove"></span></a>'
      
      Gre340.vent.trigger "add:cart:item",quiz_id,package_id,remove_btn_template,@

    $('body').on 'click','a.remove-cart-btn',(event)->
      event.preventDefault()
      
      if $(@).data('item-type') is "quiz"
        add_btn_template = '<a href="#" rel="tooltip" class="btn add-cart-btn" data-disabled-with="adding.." data-item-type="quiz" data-value="<%= quiz_id %>" data-original-title="Add to Cart"><span class="icon-plus"></span></a>'
      else
        add_btn_template = '<a href="#" rel="tooltip" class="btn add-cart-btn" data-disabled-with="adding.." data-item-type="package" data-value="<%= package_id %>" data-original-title="Add to Cart"><span class="icon-plus"></span></a>'
      
      Gre340.vent.trigger "remove:cart:item",$(@).data('id'),add_btn_template,@

    $('body').tooltip
      selector: '[rel=tooltip]'
      placement: 'bottom'
  Views.addFinalizer ->
    console.log 'closing cart view'
    Views.cartView.close()