module UnifiedPayment
  module Utility
    require 'unified_payment/client'

    def create_order_at_unified(amount, options)
      3.times do |attempt|
        begin
          @response = Client.create_order(amount, options)
          UnifiedPayment::Transaction.create(:url => @response['url'], :gateway_order_id => @response['orderId'], :gateway_session_id => @response['sessionId'])
          break
        rescue
          @response = false
        end
      end
      @response
    end

    def extract_url_for_unified_payment(response)
      response['url'] + '?' + 'ORDERID=' + response['orderId'] + '&' + 'SESSIONID=' + response['sessionId']
    end
    
    def approved_at_gateway?
      get_unified_order_status == 'APPROVED' 
    end

    private
    def get_unified_order_status
      response = Client.get_order_status(gateway_order_id, gateway_session_id)
      response['orderStatus']
    end
  end 
end