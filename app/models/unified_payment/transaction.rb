module UnifiedPayment
  class Transaction < ActiveRecord::Base
    include Utility
    self.table_name = "unified_payment_transactions"
  
    def self.create_order_at_unified(amount, options)
      3.times do |attempt|
        begin
          @response = Client.create_order((amount.to_f)*100, options)
          create(:url => @response['url'], :gateway_order_id => @response['orderId'], :gateway_session_id => @response['sessionId'], :xml_response => @response['xml_response'].to_s)
          break
        rescue
          @response = false
        end
      end
      @response
    end

    def self.extract_url_for_unified_payment(response)
      response['url'] + '?' + 'ORDERID=' + response['orderId'] + '&' + 'SESSIONID=' + response['sessionId']
    end
  end
end