module Payplug
  class CartsController < ApplicationController

    # GET /payplug/carts
    def index
      authenticate
      @page = paginate(params[:page])
      original_carts = Payplug.cart_klass.
                               order("updated_at DESC").
                               limit(@page[:limit]).
                               offset(@page[:offset])
      @carts = original_carts.map{|c| c.extend(Payplug::Cart) }
    end
    
    # GET /payplug/cart/1
    def show
      @cart = Payplug::Cart.find(params[:id])
      #@cart.finalize_amount
    end
    
    # GET /payplug/1/details
    def details
      original_cart = Payplug.cart_klass.find(params[:id])
      @cart = original_cart.extend(Payplug::Cart)
    end
    
    def thanks
      render :text => "thanks"
    end  
  end
end