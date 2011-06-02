class PaypalNotification < Payplug::Notification

  # Set the "txn_id" as transaction_id
  # Handle test IPNs "test_ipn"
  # Handle resent IPNs "resend"
  
  def correct_txn_type?
    params[:txn_type] == "cart"
  end

  def is_valid?
    do_validation(params)    
  end

  def cart_id
    params[:invoice].to_i
  end
    
  def cart
    @cart ||= Payplug.find_cart(cart_id)
  end
  
    
    
  private
  
  def do_validation    
    parameters = params.merge{"cmd"=>"_notify-validate"}
    response = Net::HTTP.post_form(URI.parse('http://www.example.com/search.cgi'), parameters)    
    case response
    when 'VERIFIED' :   return true      
    when 'INVALID'  :   return false
    else            :   raise "Can't validate this notification - #{id}"  
  end
  
end
