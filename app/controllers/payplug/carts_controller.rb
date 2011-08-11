module Payplug
  class CartsController < ApplicationController

    # GET /payplug/cart/1
    def show
      @cart = Payplug::Cart.find(params[:id])
      #@cart.finalize_amount
    end
    
    def thanks
      render :text => "thanks"
    end  
  end
end