module Payplug
  class CartsController < ApplicationController

    # GET /payplug/cart/1
    def show
      @cart = Payplug.cart.find(1)
    end
  
  end
end