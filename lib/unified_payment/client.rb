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

    MERCHANT_NAME = 'WESTAYCUTE'

    include HTTParty
    format :xml
    base_uri 'http://127.0.0.1:5555'
    
    # debug_output
    follow_redirects(50)

    def success?
      self["orderId"]
    end

    def self.create_order(amount, options={})
      xml_builder = ::Builder::XmlMarkup.new
      xml_builder.instruct!
      xml_builder.TKKPG { |tkkpg|
        tkkpg.Request { |request|
          request.Operation("CreateOrder")
          request.Language(options[:language] ? options[:language] : "EN")
          request.Order { |order|
            order.Merchant(MERCHANT_NAME)
            order.Amount(amount)
            order.Currency(options[:currency] ? options[:currency] : "566")
            order.Description(options[:description] ? options[:description] : "Test Order")
            order.ApproveURL(options[:approve_url])
            order.CancelURL(options[:cancel_url])
            order.DeclineURL(options[:decline_url])
            if options[:add_params]
              order.AddParams do |ap|
                ap.email(options[:add_params][:email]) if options[:add_params][:email]
                ap.email(options[:add_params][:phone]) if options[:add_params][:phone]
              end
            end
          }
        }
      }

      begin
        response = post('/Exec', :body => xml_builder.target!)
      rescue => e
        raise Error.new("Unable to send create order request to Unified Payments Ltd. ERROR: " + e.message)
      end

      if response["TKKPG"]["Response"]["Status"] == "00"
        url = response["TKKPG"]["Response"]["Order"]["URL"]
        orderId = response["TKKPG"]["Response"]["Order"]["OrderID"]
        sessionId = response["TKKPG"]["Response"]["Order"]["SessionID"]

        return { "url"          => url,# + "?ORDERID=" + orderId + "&SESSIONID=" + sessionId,
                 "sessionId"    => sessionId,
                 "orderId"      => orderId,
                 "xml_response" => response
               }
      else
        raise Error.new("CreateOrder Failed", response)
      end

    end

    def self.get_order_status(orderId, sessionId)
      xml_builder = Builder::XmlMarkup.new
      xml_builder.instruct!
      xml_builder.TKKPG { |tkkpg|
        tkkpg.Request { |request|
          request.Operation("GetOrderStatus")
          request.Language("EN")
          request.Order { |order|
            order.Merchant(MERCHANT_NAME)
            order.OrderID(orderId) }
          request.SessionID(sessionId)
        }
      }

      begin
        response = post('/Exec', :body => xml_builder.target! )
      rescue => e
        raise Error.new("################### Unable to send get order status request to Unified Payments Ltd " + e.message)
      end

      if response["TKKPG"]["Response"]["Status"] == "00"
        orderId = response["TKKPG"]["Response"]["Order"]["OrderID"]
        orderStatus = response["TKKPG"]["Response"]["Order"]["OrderStatus"]
        
        return { "orderStatus" => orderStatus,
                  "orderId" => orderId,
                  "xml_response" => response }      
      else
        raise UnifiedPaymentError.new("GetOrderStatus Failed", response)
      end

    end

    def self.reverse(orderId, sessionId)
      xml_builder = Builder::XmlMarkup.new
      xml_builder.instruct!
      xml_builder.TKKPG { |tkkpg|
        tkkpg.Request { |request|
          request.Operation("Reverse")
          request.Language("EN")
          request.Order { |order|
            order.Merchant(MERCHANT_NAME)
            order.OrderID(orderId) }
          request.SessionID(sessionId)
        }
      }

      begin
        response = post('/Exec', :body => xml_builder.target! )
      rescue => e
        raise UnifiedPaymentError.new("################### Unable to send Reverse request to Unified Payments Ltd " + e.message)
      end

      pp response

      if response["TKKPG"]["Response"]["Status"] == "00"
        orderId = response["TKKPG"]["Response"]["Order"]["OrderID"]
        respCode = response["TKKPG"]["Response"]["Reversal"]["RespCode"]
        respMessage = response["TKKPG"]["Response"]["Reversal"]["RespMessage"]

        return { "orderId" => orderId,
                  "respCode" => respCode,
                  "respMessage" => respMessage,
                  "xml_response" => response }
      else
        raise UnifiedPaymentError.new("Reverse Request Failed", response)
      end

    end

  end

end