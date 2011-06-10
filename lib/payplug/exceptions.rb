module Payplug
  
  class NotificationException < Exception
    def handle 
      Rails.logger.error self.message + self.backtrace
    end
  end
  
  class CartNotFoundException < Exception
  end
  
  class DuplicateCartProcessingReqestException < Exception
  end
  
  class UnhandleableNotificationException < NotificationException
  end
  
  class GoogleCheckoutNotificationException < NotificationException
  end
  
  class InvalidParametersException < GoogleCheckoutNotificationException
  end

  class NotificationHistoryRequestException < GoogleCheckoutNotificationException
  end
  
  class InconsistentFinancialOrderStateException < GoogleCheckoutNotificationException
  end
  
  class OrderAmountMismatchException < GoogleCheckoutNotificationException
  end
  
  class ChargeAndShipOrderCommandException < GoogleCheckoutNotificationException
  end
  
end