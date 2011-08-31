module Payplug

  autoload :Notification, File.expand_path("../../../app/models/payplug/notification.rb", __FILE__)
  
  class GoogleCheckoutNotification < Notification
    include Payplug::GoogleCheckoutParams
        
    #def self.preprocess(parameters)
    #  snn = SerialNumberNotification.new(:params => parameters)
    #  snn.save_as(:unprocessed)
    #  snn.process
    #  full_notification = snn.fn
    #end
          
    def acknowledgement
      { :status=>200, 
        :content_type=>'text/xml', 
        :text=>"<notification-acknowledgment xmlns=\"http://checkout.google.com/schema/2\"  serial-number=\"#{serial_number}\" />" }
    end     
    
    def error_response
      { :status => 500, 
        :text => "Error" }
    end       
    
    def process
      self.save_as(:unidentified)
      Rails.logger.warn "Tried processing unidentified notification #{self.id}"      
    end
    
  end




  class SerialNumberNotification < GoogleCheckoutNotification    
    after_initialize :validate_and_init
    
    def validate_and_init
      raise InvalidNotificationParamsException unless self.serial_number_notification?
      self.gateway = "google"
    end
    
    def fetch_fn
      fn_raw = send__notification_history_request
      fn_type = GoogleCheckout.notification_type(fn_raw)
      fn_klass = GoogleCheckout.notification_klass(fn_type)
      @fn = fn_klass.new(:raw_params => fn_raw)
    end
        
    def send__notification_history_request
      data = { "_type"         => "notification-history-request", 
               "serial-number" => serial_number }
      args = { :method    => :post,
               :url       => Payplug::GoogleCheckout.notification_history_url, 
               :user      => Payplug::GoogleCheckout.merchant_id, 
               :password  => Payplug::GoogleCheckout.merchant_key, 
               :payload   => data      }
      begin
        response = ::RestClient::Request.execute(args)                    
      rescue => e
        Rails.logger.error "|--- Args:#{args}, Response:#{response}, Exception:#{e.class.to_s} ---|"
        ""
      end
    end
    
  end




  class NewOrderNotification < GoogleCheckoutNotification      
    after_initialize :validate_and_init
    
    def validate_and_init
      raise InvalidNotificationParamsException unless self.new_order_notification?
      self.gateway = "google"
      self.transaction_id = google_order_number
    end
    
    def process
      save_as(:processed)
    end    
  end
  
  
  
  
  class AuthorizationAmountNotification < GoogleCheckoutNotification  
    after_initialize :validate_and_init
    
    def validate_and_init
      raise InvalidNotificationParamsException unless self.authorization_amount_notification?
      self.gateway = "google"
      self.transaction_id = google_order_number
    end
    
    def process
      save_as(:processing)
      perform_checks
      initiate_delivery
      capture_payment
      save_as(:processed)
    end

    def perform_checks
      cart_existence_check
      order_amount_match_check
      financial_order_state_check
    end

    def cart_existence_check
      raise CartNotFoundException if cart.nil? 
      raise DuplicateCartProcessingReqestException if cart.processed?
    end
    
    def order_amount_match_check
      raise OrderAmountMismatchException unless (order_amount_matches? && order_currency_matches?) 
    end
    
    def financial_order_state_check
      raise InconsistentFinancialOrderStateException unless order_chargeable?
    end
    
    def initiate_delivery
      cart.success      
    end

    def capture_payment
      send__charge_and_ship_order_command
    end
      
    def send__charge_and_ship_order_command      
      data = { "_type"                => "charge-and-ship-order", 
                "google-order-number" => google_order_number, 
                "amount"              => authorization_amount, 
                "amount.currency"     => authorization_currency, 
                "send-email"          => "true"       }
       args = { :method   => :post,
                :url      => Payplug::GoogleCheckout.order_processing_url, 
                :user     => Payplug::GoogleCheckout.merchant_id, 
                :password => Payplug::GoogleCheckout.merchant_key, 
                :payload  => data      }
                
       response = ::RestClient::Request.execute(args)                        
       response_hash = Rack::Utils.parse_query(response)
       raise ChargeAndShipOrderCommandException  if(response_hash["_type"] != "request-received")
       response_hash
    end
  end  
  
  
  class OrderStateChangeNotification < GoogleCheckoutNotification
  end
    
  class OtherNotification < GoogleCheckoutNotification 
  end
  
end