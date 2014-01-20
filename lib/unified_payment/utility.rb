module UnifiedPayment
  module Utility
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