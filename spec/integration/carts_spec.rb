require 'spec_helper'

describe "carts" do 
  it "seeing an existing cart" do
    visit cart_path(1) 
    page.should have_content "This is a cart"
  end
end