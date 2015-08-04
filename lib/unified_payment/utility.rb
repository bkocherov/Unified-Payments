module UnifiedPayment
  module Utility
    def approved_at_gateway?
      get_unified_order_status == 'APPROVED' 
    end

    def get_unified_order_status
      begin
        response = Client.get_order_status(merchant_id, gateway_order_id, gateway_session_id)
      rescue
        return false
      end
      if gateway_order_status != response['orderStatus']
        self.gateway_order_status = response['orderStatus']
        return gateway_order_status
      else
        return false
      end
    end
  end 
end