module Payplug
  class NotificationsController < ApplicationController
    
    def index
      authenticate
      @session = request.session

      # basic pagination logic
      per_page = 20
      @page = params[:page].to_i
      @page = 1   if @page==0
      offset = (@page-1)*per_page

      @notifications = Notification.order("updated_at DESC").limit(per_page).offset(offset)
    end
    
    def show
      authenticate
      @notification = Notification.find(params[:id])      
    end
    
    protected    
    def authenticate
      authorized = PayplugHelper.authenticate(session)
      raise "You are not authorized to view this page"  unless authorized
    end
    
    def authenticate1
      authenticate_or_request_with_http_basic do |username, password|
        username == Payplug.http_basic_username && 
        password == Payplug.http_basic_password
      end
    end
    
  end
end