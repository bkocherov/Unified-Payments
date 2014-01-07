require 'httparty'
require 'builder'
module UnifiedPayment
# This is the usual error raised on any UnifiedPayment related Errors
  class Error < RuntimeError

    attr_accessor :http_response, :error, :user_error

    def initialize(error, xml_response=nil, user_error=nil)
      @error = error
      @xml_response = xml_response
      @user_error = user_error
    end

    def to_s
      return "#{ user_error } (#{ error })" if user_error
      "#{ error }"
    end

  end

  class Client

    MERCHANT_NAME = UnifiedPayment.config[:merchant_name]

    include HTTParty
    format :xml
    base_uri UnifiedPayment.config[:base_uri]
    
    # debug_output
    follow_redirects(50)

    def success?
      self["orderId"]
    end

    def self.build_xml_for_create(amount, options)
      xml_builder = ::Builder::XmlMarkup.new
      xml_builder.instruct!
      xml_builder.TKKPG { |tkkpg|
        tkkpg.Request { |request|
          request.Operation("CreateOrder")
          request.Language(options[:language] || "EN")
          request.Order { |order|
            order.Merchant(MERCHANT_NAME)
            order.Amount(amount)
            order.Currency(options[:currency] || "566")
            order.Description(options[:description] || "Test Order")
            order.ApproveURL(options[:approve_url])
            order.CancelURL(options[:cancel_url])
            order.DeclineURL(options[:decline_url])
            if params_to_add = options[:add_params]
              order.AddParams do |add_param|
                add_param.email(params_to_add[:email]) if params_to_add[:email]
                add_param.phone(params_to_add[:phone]) if params_to_add[:phone]
              end
            end
          }
        }
      }
      xml_builder
    end
    
    def self.send_request_for_create(amount, options)
      xml_builder = build_xml_for_create(amount, options)

      begin
        xml_response = post('/Exec', :body => xml_builder.target!)
      rescue => exception
        raise Error.new("Unable to send create order request to Unified Payments Ltd. ERROR: " + exception.message)
      end
      xml_response
    end

    def self.create_order(amount, options={})
      xml_response = send_request_for_create(amount, options)
      response = xml_response["TKKPG"]["Response"]
      if response["Status"] == "00"
        response_order_details = response["Order"] 

        return { "url"          => response_order_details["URL"],
                 "sessionId"    => response_order_details["SessionID"],
                 "orderId"      => response_order_details["OrderID"],
                 "xml_response" => xml_response
               }
      else
        raise Error.new("CreateOrder Failed", response)
      end
    end

    def self.build_xml_for(operation, order_id, session_id)
      xml_builder = Builder::XmlMarkup.new
      xml_builder.instruct!
      xml_builder.TKKPG { |tkkpg|
        tkkpg.Request { |request|
          request.Operation(operation)
          request.Language("EN")
          request.Order { |order|
            order.Merchant(MERCHANT_NAME)
            order.OrderID(order_id) }
          request.SessionID(session_id)
        }
      }
      xml_builder
    end

    def self.send_request_for(operation, order_id, session_id)
      xml_request = build_xml_for(operation, order_id, session_id)
      begin
        response = post('/Exec', :body => xml_request.target! )
      rescue => exception
        raise Error.new("################### Unable to send " + operation + " request to Unified Payments Ltd " + exception.message)
      end
      response
    end

    def self.get_order_status(order_id, session_id)
      xml_response = send_request_for("GetOrderStatus", order_id, session_id)
      response = xml_response["TKKPG"]["Response"]

      if response["Status"] == "00"
        response_order_details = response["Order"] 
        
        return { "orderStatus" => response_order_details["OrderStatus"],
                  "orderId" => response_order_details["OrderID"],
                  "xml_response" => xml_response }      
      else
        raise Error.new("GetOrderStatus Failed", xml_response)
      end

    end

    def self.reverse(order_id, session_id)
      xml_response = send_request_for("Reverse", order_id, session_id)
      response = xml_response["TKKPG"]["Response"]
      if response["Status"] == "00"
        response_order_id, response_reversal_details = response["Order"]["OrderID"], response["Reversal"]
        
        return { "orderId" => response_order_id,
                  "respCode" => response_reversal_details["RespCode"],
                  "respMessage" => response_reversal_details["RespMessage"],
                  "xml_response" => xml_response }
      else
        raise Error.new("Reverse Request Failed", xml_response)
      end
    end
  end
end