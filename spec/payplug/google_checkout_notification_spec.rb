require 'spec_helper'

describe "GoogleCheckoutNotification" do
  
  it "+self.preprocess+ should take the serial-number notification and get and get the corresponding full notification" do
    serial_number_notification_params = { "serial-number" => "923823874108605-00001-7" }
    RestClient::Request.stubs(:execute).returns("dummy-google-checkout-notification")
    
    fn = Payplug::GoogleCheckoutNotification.preprocess(serial_number_notification_params)
    fn.should be_a(Payplug::GoogleCheckoutNotification)
  end

  it "+acknowledgement+ should give a hash with status 200, content type xml, and content text containing serial number" do
    gcn = Payplug::GoogleCheckoutNotification.new(:params=>{"serial-number" => "923823874108605-00001-7"})
    expected_acknowledgement = { 
      :status => 200, 
      :content_type => 'text/xml', 
      :text=> "<notification-acknowledgment xmlns=\"http://checkout.google.com/schema/2\"  serial-number=\"923823874108605-00001-7\" />" 
      }
    gcn.acknowledgement.should == expected_acknowledgement
  end    
  
  it "+error_response+ should give a hash with status 500 and text saying Error" do
    gcn = Payplug::GoogleCheckoutNotification.new(:params=>{"serial-number" => "923823874108605-00001-7"})
    expected_error_response = {:status => 500, :text => "Error" }
    gcn.error_response.should == expected_error_response
  end
  
end

describe "SerialNumberNotification" do
  
  it "initialization should raise exception if parameters don't contain the serial number" do
    lambda{ 
      Payplug::SerialNumberNotification.new(:params => "wrong-params") 
    }.should raise_error(Payplug::InvalidNotificationParamsException)
  end
  
  it "intialization should set the gateway as google" do
    snn = Payplug::SerialNumberNotification.new(:params => {"serial-number" => "923823874108605-00001-7"}) 
    snn.gateway.should == "google"
  end
  
  it "+process+ should fetch the full notification from google checkout servers" do
    RestClient::Request.expects(:execute)
    snn = Payplug::SerialNumberNotification.new(:params => {"serial-number" => "923823874108605-00001-7"}) 
    snn.process
  end
  
  it "+process+ should set up a NewOrderNotification object when a new-order-notification is fetched" do
    stubbed_new_order_notification = "_type=new-order-notification"
    RestClient::Request.stubs(:execute).returns(stubbed_new_order_notification)
    snn = Payplug::SerialNumberNotification.new(:params => {"serial-number" => "923823874108605-00001-7"}) 
    snn.process
    snn.fn.should be_a(Payplug::NewOrderNotification)
  end
  
  it "+process+ should save the serial number notification as processed" do
    RestClient::Request.stubs(:execute).returns
    snn = Payplug::SerialNumberNotification.new(:status => nil, :params => {"serial-number" => "923823874108605-00001-7"}) 
    snn.process
    snn.status.should == :processed
  end
  
  it "+fetch_fn+ should send the notification-history API request to the google checkout servers to get full notification" do
    serial_number = "923823874108605-00001-7"

    expected_parameters = {
      :method    => :post,
      :url       => Payplug::GoogleCheckout.notification_history_url, 
      :user      => Payplug::GoogleCheckout.merchant_id, 
      :password  => Payplug::GoogleCheckout.merchant_key, 
      :payload   => { "_type"         => "notification-history-request", 
                      "serial-number" => serial_number}
    }
    RestClient::Request.expects(:execute).with(expected_parameters)
    snn = Payplug::SerialNumberNotification.new(:params => {"serial-number" => serial_number}) 
    snn.fetch_fn
  end
  
  it "+fetch_fn+ parses the response of notification-history-API request to get a parameter hash" do
    sample_response = "_type=new-order-notification&google-order-number=558886138904937&"
    expected_parameter_hash = {"_type" => "new-order-notification", "google-order-number" => "558886138904937" }

    RestClient::Request.stubs(:execute).returns(sample_response)
    snn = Payplug::SerialNumberNotification.new(:params => {"serial-number" => "923823874108605-00001-7"})
    snn.fetch_fn
    
    parsed_parameters = snn.instance_variable_get(:@params_fn)
    parsed_parameters.should == expected_parameter_hash
  end  
end


describe "NewOrderNotification" do

  it "intialization should raise exeption if the type parameter is incorrect" do
    lambda {
      Payplug::NewOrderNotification.new(:params=>{"_type" => "incorrect-type"})
    }.should raise_error(Payplug::InvalidNotificationParamsException)    
  end
  
  it "initialization should set the google as gateway and google-order-numner as transaction-id" do
    non = Payplug::NewOrderNotification.new(:params=>{"_type" => "new-order-notification", "google-order-number" => "ABC-123"})
    non.gateway.should == "google"
    non.transaction_id.should == "ABC-123"
  end
  
  it "+process+ should save the notification as processed" do
    non = Payplug::NewOrderNotification.new(:params=>{"_type" => "new-order-notification"}, :status => nil)
    non.process
    Payplug::Notification.exists?(non).should be_true
    non.status.should == :processed
  end
  
end