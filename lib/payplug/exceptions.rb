module Payplug
  
  class PayplugException < Exception
    def handle
      Rails.logger.error self.message + self.backtrace
    end
  end
  
  class NotificationException < PayplugException
  end
  
  class CartNotFoundException < PayplugException
  end
  
  class DuplicateCartProcessingReqestException < PayplugException
  end
  
  class UnhandleableNotificationException < NotificationException
  end
  
  class GoogleCheckoutNotificationException < NotificationException
  end
  
  class InvalidNotificationParamsException < GoogleCheckoutNotificationException
  end

  class NotificationHistoryRequestException < GoogleCheckoutNotificationException
  end
  
  class InconsistentFinancialOrderStateException < GoogleCheckoutNotificationException
  end
  
  class OrderAmountMismatchException < GoogleCheckoutNotificationException
  end
  
  class ChargeAndShipOrderCommandException < GoogleCheckoutNotificationException
  end
  
  class PaypalException < PayplugException
  end
  
  class NotificationVerificationError < PaypalException
  end
  
  
end