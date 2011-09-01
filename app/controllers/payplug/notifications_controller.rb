module Payplug
  class NotificationsController < ApplicationController
    
    def index
      authenticate
      @page = paginate(params[:page])
      @notifications = Notification.order("updated_at DESC").limit(@page[:limit]).offset(@page[:offset])
    end
    
    def show
      authenticate
      @notification = Notification.find(params[:id])      
    end
    
    protected        
    def authenticate1
      authenticate_or_request_with_http_basic do |username, password|
        username == Payplug.http_basic_username && 
        password == Payplug.http_basic_password
      end
    end
    
  end
end