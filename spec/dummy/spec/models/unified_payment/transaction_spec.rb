require 'spec_helper'

describe UnifiedPayment::Transaction do
  it { UnifiedPayment::Transaction.table_name.should eq('unified_payment_transactions') }
  [:gateway_session_id, :gateway_order_id, :url, :merchant_id, :approval_code].each do |attribute|
    it { should allow_mass_assignment_of attribute }
  end

  let(:unified_payment) { UnifiedPayment::Transaction.new }
  context 'utility methods' do
    describe '#create_order_at_unified' do
      context 'attempt fails' do
        context 'never' do
          before do
            UnifiedPayment::Client.stub(:create_order).and_return({ 'url' => 'https://mpi.valucardnigeria.com:443/index.jsp', 'orderId' => '12345', 'sessionId' => '040C78AA2FACF4B1164EDAA27BB281A7'})
          end

          it 'calls to client only once with no error raised' do
            UnifiedPayment::Client.should_receive(:create_order).and_return({ 'url' => 'https://mpi.valucardnigeria.com:443/index.jsp', 'orderId' => '12345', 'sessionId' => '040C78AA2FACF4B1164EDAA27BB281A7'})
            UnifiedPayment::Transaction.create_order_at_unified(200, {})
          end

          it 'creates a unified transaction entry' do
            UnifiedPayment::Transaction.should_receive(:create).with({ :url => 'https://mpi.valucardnigeria.com:443/index.jsp', :gateway_order_id => '12345', :gateway_session_id => '040C78AA2FACF4B1164EDAA27BB281A7', :xml_response => ""})
            UnifiedPayment::Transaction.create_order_at_unified(200, {})
          end

          it 'sets response' do
            UnifiedPayment::Transaction.create_order_at_unified(200, {}).should eq({ 'url' => 'https://mpi.valucardnigeria.com:443/index.jsp', 'orderId' => '12345', 'sessionId' => '040C78AA2FACF4B1164EDAA27BB281A7'})
          end
        end

        context 'once' do
          before do
            UnifiedPayment::Client.stub(:create_order).once.and_raise(UnifiedPayment::Error.new("Unable to send create order request to Unified Payments Ltd. ERROR: Connection refused - connect(2)") )
            UnifiedPayment::Client.stub(:create_order).once.and_return({ 'url' => 'https://mpi.valucardnigeria.com:443/index.jsp', 'orderId' => '12345', 'sessionId' => '040C78AA2FACF4B1164EDAA27BB281A7'})
          end
          
          it 'calls to client twice with error raise once' do
            UnifiedPayment::Client.should_receive(:create_order).once.and_raise(UnifiedPayment::Error.new("Unable to send create order request to Unified Payments Ltd. ERROR: Connection refused - connect(2)") )
            UnifiedPayment::Client.should_receive(:create_order).once.and_return({ 'url' => 'https://mpi.valucardnigeria.com:443/index.jsp', 'orderId' => '12345', 'sessionId' => '040C78AA2FACF4B1164EDAA27BB281A7'})
            UnifiedPayment::Transaction.create_order_at_unified(200, {})
          end

          it 'sets response' do
            UnifiedPayment::Transaction.create_order_at_unified(200, {}).should eq({ 'url' => 'https://mpi.valucardnigeria.com:443/index.jsp', 'orderId' => '12345', 'sessionId' => '040C78AA2FACF4B1164EDAA27BB281A7'})
          end
        end

        context 'twice' do
          before do
            UnifiedPayment::Client.stub(:create_order).twice.and_raise(UnifiedPayment::Error.new("Unable to send create order request to Unified Payments Ltd. ERROR: Connection refused - connect(2)") )
            UnifiedPayment::Client.stub(:create_order).once.and_return({ 'url' => 'https://mpi.valucardnigeria.com:443/index.jsp', 'orderId' => '12345', 'sessionId' => '040C78AA2FACF4B1164EDAA27BB281A7'})
          end
          
          it 'calls to client thrice with error raise twice' do
            UnifiedPayment::Client.should_receive(:create_order).twice.and_raise(UnifiedPayment::Error.new("Unable to send create order request to Unified Payments Ltd. ERROR: Connection refused - connect(2)") )
            UnifiedPayment::Client.should_receive(:create_order).once.and_return({ 'url' => 'https://mpi.valucardnigeria.com:443/index.jsp', 'orderId' => '12345', 'sessionId' => '040C78AA2FACF4B1164EDAA27BB281A7'})
            UnifiedPayment::Transaction.create_order_at_unified(200, {})
          end

          it 'sets response' do
            UnifiedPayment::Transaction.create_order_at_unified(200, {}).should eq({ 'url' => 'https://mpi.valucardnigeria.com:443/index.jsp', 'orderId' => '12345', 'sessionId' => '040C78AA2FACF4B1164EDAA27BB281A7'})
          end
        end

        context 'thrice' do
          before do
            UnifiedPayment::Client.stub(:create_order).and_raise(UnifiedPayment::Error.new("Unable to send create order request to Unified Payments Ltd. ERROR: Connection refused - connect(2)"))
          end

          it 'calls to client thrice with error raised thrice' do
            UnifiedPayment::Client.should_receive(:create_order).exactly(3).times.and_raise(UnifiedPayment::Error.new("Unable to send create order request to Unified Payments Ltd. ERROR: Connection refused - connect(2)"))
            UnifiedPayment::Transaction.create_order_at_unified(200, {})
          end

          it 'sets response false' do
            UnifiedPayment::Transaction.create_order_at_unified(200, {}).should be_false
          end
        end
      end
    end

    describe '#extract_url_for_unified_payment' do
      before do
        @response = { 'url' => 'https://mpi.valucardnigeria.com:443/index.jsp', 'orderId' => '12345', 'sessionId' => '040C78AA2FACF4B1164EDAA27BB281A7'}
      end

      it { UnifiedPayment::Transaction.extract_url_for_unified_payment(@response).should eq('https://mpi.valucardnigeria.com:443/index.jsp?ORDERID=12345&SESSIONID=040C78AA2FACF4B1164EDAA27BB281A7') }
    end

    describe '#approved_at_gateway?' do
      context 'when approved' do
        before { unified_payment.stub(:get_unified_order_status).and_return('APPROVED') }

        it { unified_payment.should be_approved_at_gateway }
      end

      context 'when not approved' do
        before { unified_payment.stub(:get_unified_order_status).and_return('NOT-APPROVED') }

        it { unified_payment.should_not be_approved_at_gateway }
      end
    end

    describe '#get_unified_order_status' do
      before do
        unified_payment.stub(:gateway_order_id).and_return('12345')
        unified_payment.stub(:gateway_session_id).and_return('040C78AA2FACF4B1164EDAA27BB281A7')
        UnifiedPayment::Client.stub(:get_order_status).with(unified_payment.gateway_order_id, unified_payment.gateway_session_id).and_return('orderStatus' => 'APPROVED')
      end

      it 'calls client' do 
        UnifiedPayment::Client.should_receive(:get_order_status).with(unified_payment.gateway_order_id, unified_payment.gateway_session_id).and_return('orderStatus' => 'APPROVED')
        unified_payment.send(:get_unified_order_status)
      end

      it { unified_payment.send(:get_unified_order_status).should eq('APPROVED')}
    end
  end
end