module Payplug
  class NotificationsController < ApplicationController
    
    def index
      authenticate
      @notifications = Notification.all
    end
    
    def show
      authenticate
      @notification = Notification.find(params[:id])      
    end
    
    protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == Payplug.http_basic_username && 
        password == Payplug.http_basic_password
      end
    end
    
  end
end