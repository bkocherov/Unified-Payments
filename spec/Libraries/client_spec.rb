require 'spec_helper'

describe UnifiedPayment::Client do  
  describe '#create_order' do
    before do
      @xml_builder = Builder::XmlMarkup.new
      Builder::XmlMarkup.stub(:new).and_return(@xml_builder)
    end

    context 'not able to reach gateway' do
      it { expect { UnifiedPayment::Client.create_order(200)}.to raise_error(UnifiedPayment::Error, "Unable to send create order request to Unified Payments Ltd. ERROR: Connection refused - connect(2)") }
    end

    context 'response status is not 00' do
      before do
        my_response = { "TKKPG" => { "Response" => { "Operation"=>"CreateOrder", "Status"=>"01", "Order"=>{"OrderID"=>"1086880", "SessionID"=>"740A7AB7EB527908EB9507154CFAD389", "URL"=> "https://mpi.valucardnigeria.com:443/index.jsp"}}}}
        UnifiedPayment::Client.stub(:post).and_return(my_response)
      end

      it { expect { UnifiedPayment::Client.create_order(200)}.to raise_error(UnifiedPayment::Error, "CreateOrder Failed") }
    end

    describe 'method calls' do
      before do
        my_response = { "TKKPG" => { "Response" => { "Operation"=>"CreateOrder", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "SessionID"=>"740A7AB7EB527908EB9507154CFAD389", "URL"=> "https://mpi.valucardnigeria.com:443/index.jsp"}}}}
        UnifiedPayment::Client.stub(:post).and_return(my_response)
      end

      it { Builder::XmlMarkup.should_receive(:new).and_return(@xml_builder) }
      it { @xml_builder.should_receive(:instruct!).and_return(true) }

      after { UnifiedPayment::Client.create_order(200) }
    end

    describe 'sends request along options' do
      before do
        my_response = { "TKKPG" => { "Response" => { "Operation"=>"CreateOrder", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "SessionID"=>"740A7AB7EB527908EB9507154CFAD389", "URL"=> "https://mpi.valucardnigeria.com:443/index.jsp"}}}}
        UnifiedPayment::Client.stub(:post).and_return(my_response)
      end

      context 'default options' do
        before do
          UnifiedPayment::Client.create_order(200, :approve_url => 'approve-url', :decline_url => 'decline-url', :cancel_url => 'cancel-url')
        end
        
        it { @xml_builder.inspect.should eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><TKKPG><Request><Operation>CreateOrder</Operation><Language>EN</Language><Order><Merchant>verbose</Merchant><Amount>200</Amount><Currency>566</Currency><Description>Test Order</Description><ApproveURL>approve-url</ApproveURL><CancelURL>cancel-url</CancelURL><DeclineURL>decline-url</DeclineURL></Order></Request></TKKPG><inspect/>")}
      end
      
      context 'Currency, Description and Language' do
        before do
          UnifiedPayment::Client.create_order(200,:currency => '444', :description => 'unified-payment-order', :language => 'HIN', :approve_url => 'approve-url', :decline_url => 'decline-url', :cancel_url => 'cancel-url')
        end  

        it { @xml_builder.inspect.should eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><TKKPG><Request><Operation>CreateOrder</Operation><Language>HIN</Language><Order><Merchant>verbose</Merchant><Amount>200</Amount><Currency>444</Currency><Description>unified-payment-order</Description><ApproveURL>approve-url</ApproveURL><CancelURL>cancel-url</CancelURL><DeclineURL>decline-url</DeclineURL></Order></Request></TKKPG><inspect/>")}
      end

      context 'with email and phone' do
        before do
          UnifiedPayment::Client.create_order(200, :add_params => { :email => 'test-email@test.com', :phone => '07123456789' }, :currency => '444', :description => 'unified-payment-order', :language => 'HIN', :approve_url => 'approve-url', :decline_url => 'decline-url', :cancel_url => 'cancel-url')
        end  

        it { @xml_builder.inspect.should eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><TKKPG><Request><Operation>CreateOrder</Operation><Language>HIN</Language><Order><Merchant>verbose</Merchant><Amount>200</Amount><Currency>444</Currency><Description>unified-payment-order</Description><ApproveURL>approve-url</ApproveURL><CancelURL>cancel-url</CancelURL><DeclineURL>decline-url</DeclineURL><AddParams><email>test-email@test.com</email><email>07123456789</email></AddParams></Order></Request></TKKPG><inspect/>")}
      end
    end
  end

  describe '.get_order_status' do
    before do
      @xml_builder = Builder::XmlMarkup.new
      Builder::XmlMarkup.stub(:new).and_return(@xml_builder)
    end

    it { expect { UnifiedPayment::Client.get_order_status(1086880, '740A7AB7EB527908EB9507154CFAD389') }.to raise_error(UnifiedPayment::Error, '################### Unable to send get order status request to Unified Payments Ltd Connection refused - connect(2)')}
  
    context 'response status is not 00' do
      before do
        my_response = {"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"01", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}}}}
        UnifiedPayment::Client.stub(:post).and_return(my_response)
      end

      it { expect { UnifiedPayment::Client.get_order_status(1086880, '740A7AB7EB527908EB9507154CFAD389') }.to raise_error(UnifiedPayment::Error, 'GetOrderStatus Failed') }
    end

    describe 'sends request along options' do
      before do
        my_response = {"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}}}}
        UnifiedPayment::Client.stub(:post).and_return(my_response)
        UnifiedPayment::Client.get_order_status(1086880, '740A7AB7EB527908EB9507154CFAD389')
      end

      it { @xml_builder.inspect.should eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><TKKPG><Request><Operation>GetOrderStatus</Operation><Language>EN</Language><Order><Merchant>verbose</Merchant><OrderID>1086880</OrderID></Order><SessionID>740A7AB7EB527908EB9507154CFAD389</SessionID></Request></TKKPG><inspect/>") }
    end
  end

  describe '.reverse' do
    before do
      @xml_builder = Builder::XmlMarkup.new
      Builder::XmlMarkup.stub(:new).and_return(@xml_builder)
    end

    it { expect { UnifiedPayment::Client.reverse(1086880, '740A7AB7EB527908EB9507154CFAD389') }.to raise_error(UnifiedPayment::Error, '################### Unable to send Reverse request to Unified Payments Ltd Connection refused - connect(2)')}
  
    context 'response status is not 00' do
      before do
        my_response = {"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"01", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}}}}
        UnifiedPayment::Client.stub(:post).and_return(my_response)
      end

      it { expect { UnifiedPayment::Client.reverse(1086880, '740A7AB7EB527908EB9507154CFAD389') }.to raise_error(UnifiedPayment::Error, 'Reverse Request Failed') }
    end

    describe 'sends request along options' do
      before do
        my_response = {"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}, "Reversal" => {'RespCode' => '876', 'RespMessage' => 'resp-message' }}}}
        UnifiedPayment::Client.stub(:post).and_return(my_response)
        UnifiedPayment::Client.reverse(1086880, '740A7AB7EB527908EB9507154CFAD389')
      end

      it { @xml_builder.inspect.should eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><TKKPG><Request><Operation>Reverse</Operation><Language>EN</Language><Order><Merchant>verbose</Merchant><OrderID>1086880</OrderID></Order><SessionID>740A7AB7EB527908EB9507154CFAD389</SessionID></Request></TKKPG><inspect/>") }
    end
  end
end