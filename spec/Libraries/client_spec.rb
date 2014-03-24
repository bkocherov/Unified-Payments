require 'spec_helper'

describe UnifiedPayment::Client do  
  describe '#create_order' do
    before do
      @xml_builder = Builder::XmlMarkup.new
      Builder::XmlMarkup.stub(:new).and_return(@xml_builder)
    end

    context 'not able to reach gateway' do
      it { expect { UnifiedPayment::Client.create_order(200)}.to raise_error(UnifiedPayment::Error) }
    end

    context 'response status is not 00' do
      before do
        my_response = { "TKKPG" => { "Response" => { "Operation"=>"CreateOrder", "Status"=>"01", "Order"=>{"OrderID"=>"1086880", "SessionID"=>"740A7AB7EB527908EB9507154CFAD389", "URL"=> "https://mpi.valucardnigeria.com:443/index.jsp"}}}}
        UnifiedPayment::Client.stub(:post).with('/Exec', :body => @xml_builder.target!).and_return(my_response)
      end

      it { expect { UnifiedPayment::Client.create_order(200)}.to raise_error(UnifiedPayment::Error, "CreateOrder Failed") }
    end

    context 'response status is 00' do
      before do
        my_response = { "TKKPG" => { "Response" => { "Operation"=>"CreateOrder", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "SessionID"=>"740A7AB7EB527908EB9507154CFAD389", "URL"=> "https://mpi.valucardnigeria.com:443/index.jsp"}}}}
        UnifiedPayment::Client.stub(:post).with('/Exec', :body => @xml_builder.target!).and_return(my_response)
      end

      it { expect { UnifiedPayment::Client.create_order(200)}.not_to raise_error() }
      it { UnifiedPayment::Client.create_order(200).should eq({"url"=>"https://mpi.valucardnigeria.com:443/index.jsp", "sessionId"=>"740A7AB7EB527908EB9507154CFAD389", "orderId"=>"1086880", "Order"=>{"OrderID"=>"1086880", "SessionID"=>"740A7AB7EB527908EB9507154CFAD389", "URL"=> "https://mpi.valucardnigeria.com:443/index.jsp"}, "Status"=>"00", "xml_response"=>{"TKKPG"=>{"Response"=>{"Operation"=>"CreateOrder", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "SessionID"=>"740A7AB7EB527908EB9507154CFAD389", "URL"=>"https://mpi.valucardnigeria.com:443/index.jsp"}}}}}) }
    end

    describe 'method calls' do
      before do
        my_response = { "TKKPG" => { "Response" => { "Operation"=>"CreateOrder", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "SessionID"=>"740A7AB7EB527908EB9507154CFAD389", "URL"=> "https://mpi.valucardnigeria.com:443/index.jsp"}}}}
        UnifiedPayment::Client.stub(:post).with('/Exec', :body => @xml_builder.target!).and_return(my_response)
      end

      it { Builder::XmlMarkup.should_receive(:new).and_return(@xml_builder) }
      it { @xml_builder.should_receive(:instruct!).and_return(true) }

      after { UnifiedPayment::Client.create_order(200) }
    end

    describe 'sends request along options' do
      before do
        my_response = { "TKKPG" => { "Response" => { "Operation"=>"CreateOrder", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "SessionID"=>"740A7AB7EB527908EB9507154CFAD389", "URL"=> "https://mpi.valucardnigeria.com:443/index.jsp"}}}}
        UnifiedPayment::Client.stub(:post).with('/Exec', :body => @xml_builder.target!).and_return(my_response)
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

        it { @xml_builder.inspect.should eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><TKKPG><Request><Operation>CreateOrder</Operation><Language>HIN</Language><Order><Merchant>verbose</Merchant><Amount>200</Amount><Currency>444</Currency><Description>unified-payment-order</Description><ApproveURL>approve-url</ApproveURL><CancelURL>cancel-url</CancelURL><DeclineURL>decline-url</DeclineURL><AddParams><email>test-email@test.com</email><phone>07123456789</phone></AddParams></Order></Request></TKKPG><inspect/>")}
      end
    end
  end

  describe '.get_order_status' do
    before do
      @xml_builder = Builder::XmlMarkup.new
      Builder::XmlMarkup.stub(:new).and_return(@xml_builder)
    end

    it { expect { UnifiedPayment::Client.get_order_status(1086880, '740A7AB7EB527908EB9507154CFAD389') }.to raise_error(UnifiedPayment::Error) }
  
    context 'response status is not 00' do
      before do
        my_response = {"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"01", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}}}}
        UnifiedPayment::Client.stub(:post).with('/Exec', :body => @xml_builder.target!).and_return(my_response)
      end

      it { expect { UnifiedPayment::Client.get_order_status(1086880, '740A7AB7EB527908EB9507154CFAD389') }.to raise_error(UnifiedPayment::Error, 'GetOrderStatus Failed') }
    end

    context 'response status is 00' do
      before do
        my_response = {"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}}}}
        UnifiedPayment::Client.stub(:post).with('/Exec', :body => @xml_builder.target!).and_return(my_response)
      end

      it { expect { UnifiedPayment::Client.get_order_status(1086880, '740A7AB7EB527908EB9507154CFAD389') }.not_to raise_error() }
      it { UnifiedPayment::Client.get_order_status(1086880, '740A7AB7EB527908EB9507154CFAD389').should eq({"orderStatus"=>"CREATED", "orderId"=>"1086880", "xml_response"=>{"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}}}}}) }
    end

    describe 'sends request along options' do
      before do
        my_response = {"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}}}}
        UnifiedPayment::Client.stub(:post).with('/Exec', :body => @xml_builder.target!).and_return(my_response)
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

    it { expect { UnifiedPayment::Client.reverse(1086880, '740A7AB7EB527908EB9507154CFAD389') }.to raise_error(UnifiedPayment::Error) }
  
    context 'response status is not 00' do
      before do
        my_response = {"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"01", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}, "Reversal" => {'RespCode' => '876', 'RespMessage' => 'resp-message' }}}}
        UnifiedPayment::Client.stub(:post).with('/Exec', :body => @xml_builder.target!).and_return(my_response)
      end

      it { expect { UnifiedPayment::Client.reverse(1086880, '740A7AB7EB527908EB9507154CFAD389') }.to raise_error(UnifiedPayment::Error, 'Reverse Request Failed') }
    end

    context 'response status is 00' do
      before do
        my_response = {"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}, "Reversal" => {'RespCode' => '876', 'RespMessage' => 'resp-message' }}}}
        UnifiedPayment::Client.stub(:post).with('/Exec', :body => @xml_builder.target!).and_return(my_response)
      end

      it { expect { UnifiedPayment::Client.reverse(1086880, '740A7AB7EB527908EB9507154CFAD389') }.not_to raise_error() }
      it { UnifiedPayment::Client.reverse(1086880, '740A7AB7EB527908EB9507154CFAD389').should eq({"orderId"=>"1086880", "respCode"=>"876", "respMessage"=>"resp-message", "xml_response"=>{"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}, "Reversal"=>{"RespCode"=>"876", "RespMessage"=>"resp-message"}}}}}) }
    end

    describe 'sends request along options' do
      before do
        my_response = {"TKKPG"=>{"Response"=>{"Operation"=>"GetOrderStatus", "Status"=>"00", "Order"=>{"OrderID"=>"1086880", "OrderStatus"=>"CREATED"}, "Reversal" => {'RespCode' => '876', 'RespMessage' => 'resp-message' }}}}
        UnifiedPayment::Client.stub(:post).with('/Exec', :body => @xml_builder.target!).and_return(my_response)
        UnifiedPayment::Client.reverse(1086880, '740A7AB7EB527908EB9507154CFAD389')
      end

      it { @xml_builder.inspect.should eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><TKKPG><Request><Operation>Reverse</Operation><Language>EN</Language><Order><Merchant>verbose</Merchant><OrderID>1086880</OrderID></Order><SessionID>740A7AB7EB527908EB9507154CFAD389</SessionID></Request></TKKPG><inspect/>") }
    end
  end
end