module Payplug
  class CartsController < ApplicationController

    # GET /payplug/cart/1
    def show
      @cart = Payplug.find_cart(params[:id])
      @cart.finalize_amount
    end
    
    def thanks
      render :text => "thanks"
    end  
  end
end