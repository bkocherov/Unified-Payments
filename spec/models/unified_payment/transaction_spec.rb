require 'spec_helper'

describe UnifiedPayment::Transaction do
  it { UnifiedPayment::Transaction.table_name.should eq('unified_transactions') }
  [:gateway_session_id, :gateway_order_id, :url, :merchant_id, :approval_code].each do |attribute|
    it { should allow_mass_assignment_of attribute }
  end
end