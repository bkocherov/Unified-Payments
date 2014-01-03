module UnifiedPayment
  class Transaction < ActiveRecord::Base
    include Utility
    self.table_name = "unified_transactions"
    attr_accessible :gateway_session_id, :gateway_order_id, :url, :merchant_id, :approval_code
  end
end