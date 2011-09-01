module Payplug
  class ApplicationController < ActionController::Base

    def authenticate
      authorized = PayplugHelper.authenticate(session)
      raise "You are not authorized to view this page"  unless authorized
    end
    
    # use this way: paginate(params[:page])
    def paginate(page_param)
      per_page = 20
      page_no = page_param.to_i
      page_no = 1   if page_no==0
      offset = (page_no-1)*per_page
      {:limit => per_page, :offset => offset, :page_no => page_no}
    end

  end
end
