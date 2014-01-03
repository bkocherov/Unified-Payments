module UnifiedPayment
  module Utility
    require 'unified_payment/client'

    def create_order_at_unified(amount)
      3.times do |attempt|
        begin
          @response = Client.create_order(amount, { :approve_url => "#{root_url}pay_by_cards/approved", :cancel_url => "#{root_url}pay_by_cards/canceled", :decline_url => "#{root_url}pay_by_cards/declined" }) 
          break
        rescue
          flash[:error] = "Could not create payment at unified, please pay by other methods or try again later."
        end
      end
      @response || false
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