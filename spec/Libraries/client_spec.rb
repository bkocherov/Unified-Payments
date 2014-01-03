require 'spec_helper'

describe UnifiedPayment::Client do
  describe '#create_order' do
    before do
      # @xml_builder = Builder::XmlMarkup.new
      # Builder::XmlMarkup.stub(:new).and_return(@xml_builder)
    end

    it { expect { UnifiedPayment::Client.create_order(200)}.to raise_error(UnifiedPayment::Error) }
  end
end