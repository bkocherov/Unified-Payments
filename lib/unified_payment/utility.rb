module UnifiedPayment
  module Utility
    def approved_at_gateway?
      get_unified_order_status == 'APPROVED' 
    end

    def self.included(klass)
      klass.extend ClassMethods
    end
    
    module ClassMethods
      def stub_response
        session_id = rand(10**10)
        order_id = rand(10*5)
        {"url"=>"https://mpi.valucardnigeria.com:443/index.jsp", "sessionId"=>"#{session_id}", "orderId"=>"#{order_id}", "Order"=>{"OrderID"=>"#{order_id}", "SessionID"=>"#{session_id}", "URL"=>"https://mpi.valucardnigeria.com:443/index.jsp"}, "Status"=>"00", "xml_response"=>"(#<HTTParty::Response:0x7fb27f57d210 parsed_response={'TKKPG'=>{'Response'=>{'Operation'=>'CreateOrder', 'Status'=>'00', 'Order'=>{'OrderID'=>#{order_id}, 'SessionID'=>#{session_id}, 'URL'=>'https://mpi.valucardnigeria.com:443/index.jsp'}}}}, @response=#<Net::HTTPOK 200 OK readbody=true>, @headers={'server'=>['Apache-Coyote/1.1'], 'set-cookie'=>['JSESSIONID=B565D33ECAE49F25D09900ABD806345A; Path=/; Secure; HttpOnly'], 'content-type'=>['text/xml;charset=utf-8'], 'content-length'=>['241'], 'date'=>[#{DateTime.current}], 'connection'=>['close']}>"}
      end
    end

    private
    def get_unified_order_status
      response = Client.get_order_status(gateway_order_id, gateway_session_id)
      response['orderStatus']
    end
  end 
end